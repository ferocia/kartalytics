# frozen_string_literal: true
require 'benchmark'

# Singleton that processes the kartalytics event stream
class KartalyticsState < ApplicationRecord
  self.table_name = 'kartalytics_state'
  belongs_to :current_match, class_name: 'KartalyticsMatch'
  belongs_to :current_race, class_name: 'KartalyticsRace'

  attr_accessor :league_id

  def self.ingest(event)
    event[:timestamp] = Time.zone.parse(event[:timestamp])
    instance.tick(event.with_indifferent_access)
  end

  def self.associate_match(match)
    instance.associate_match(match)
  end

  def self.instance
    first_or_create
  end

  def tick(next_event)
    result = nil
    time = Benchmark.realtime do
      case next_event[:event_type]
      when 'players_present'     then associate_players(next_event)
      when 'race_screen'         then capture_snapshot(next_event)
      when 'match_result_screen' then finalize_match(next_event)
      when 'main_menu_screen'    then abandon_match(next_event)
      when 'intro_screen'        then setup_race(next_event)
      when 'select_character_screen' then setup_match(next_event)
      when 'race_result_screen'  then finalize_race(next_event)
      when 'loading_screen'      then ensure_race_finalized!
      else raise("Unknown event #{next_event.inspect}")
      end
      self.last_event = next_event
      result = save!
    end
    Rails.logger.info("[KartalyticsState:update] #{time}")
    result
  end

  def associate_players(event)
    kartalytics_match = current_match

    if kartalytics_match
      players = Hash[event[:data].map {|k,v| [k, Player.find_by(name: v[:name]&.downcase&.sub(/https?:\/\//, ''))]}]
      kartalytics_match.associate_players!(players)
    end
  rescue StandardError => e
    Rails.logger.error e.message
  end

  def associate_match(match)
    kartalytics_match = KartalyticsMatch.recent_unassigned_for(match.player_count).first

    if kartalytics_match
      kartalytics_match.associate_match!(match)
    else
      Rails.logger.info "Could not find a recent match to associate with kartalytics #{match.inspect}"
    end
  rescue StandardError => e
    # If anything goes wrong, swallow it for now
    Rails.logger.error e.message
  end

  def capture_snapshot(event)
    ensure_race_exists!(event[:timestamp])

    if event[:data].keys.length > current_match.player_count.to_i
      current_match.update(player_count: event[:data].keys.length)
    end

    current_race.create_snapshot(event)
  end

  def finalize_match(event)
    # Already finalized
    return if current_match.nil?

    # Ensure we get a read that matches the player count
    return if event[:data].nil? || current_match.player_count != event[:data].keys.count { |key| key.include?('player') }

    ensure_race_finalized!
    current_match.finalize!(event)

    self.current_race = nil
    self.current_match = nil
  end

  def abandon_match(_event)
    return if current_match.nil?

    match = current_match
    update(current_race: nil, current_match: nil)

    if match.races.any?(&:finished?)
      match.abandon!
    else
      match.destroy
    end
  end

  def finalize_race(event)
    # Already finalized
    return if current_race.nil?

    # recalculate player count using snapshot data
    current_match.update_player_count!

    # Ensure we get a read that matches the player count
    return if event[:data].nil? || event[:data].keys.length != current_match.player_count

    if current_race.race_snapshots.any?
      current_race.update_results!(event)
      self.current_match.update_interim_results!
    else
      current_race.destroy
    end
    self.current_race = nil
  end

  def setup_match(event)
    ensure_match_exists!
  end

  def setup_race(intro_event)
    start_time = intro_event.fetch(:timestamp) + 8.5.seconds
    course_name = intro_event.fetch(:data).fetch(:course_name)
    image_base64 = intro_event.fetch(:data).fetch(:image_base64, nil)

    # if the previous race wasn't finalised, ignore it and set up new race
    self.current_race = nil if current_race&.race_snapshots&.any?

    if !current_race
      ensure_match_exists!

      # reset created_at in case character selection was abandoned and resumed
      current_match.update(created_at: Time.now) if current_match.races.empty?

      course = KartalyticsCourse.find_or_create_by(name: course_name)
      self.current_race = KartalyticsRace.create!(match: current_match, course: course, started_at: start_time)
    end

    self.current_race.update_course_info!(course_name: course_name, image_base64: image_base64, started_at: start_time)
  end

  private

  def ensure_race_exists!(timestamp)
    ensure_match_exists!
    return unless current_race.nil?

    # Bugger - must have missed the intro screen....
    course = KartalyticsCourse.find_or_create_by(name: KartalyticsCourse::UNKNOWN_COURSE_NAME)
    self.current_race = KartalyticsRace.create!(
      match: current_match,
      course: course,
      # we can't know when the race started, so to be safe we assume it started
      # 2 minutes ago to avoid impossible course records if the course is
      # manually reassigned after the race
      started_at: timestamp - 2.minutes,
    )
  end

  def ensure_race_finalized!
    return if current_race.nil?

    # do not prematurely finalize the race on false positive
    return unless current_race.any_players_finished?

    self.current_race = nil
  end

  def ensure_match_exists!
    self.current_match = KartalyticsMatch.create! if current_match.nil?
  end
end
