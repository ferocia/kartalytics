# frozen_string_literal: true

# Singleton that processes the kartalytics event stream
class KartalyticsState < ApplicationRecord
  self.table_name = 'kartalytics_state'
  belongs_to :current_match, class_name: 'KartalyticsMatch'
  belongs_to :current_race, class_name: 'KartalyticsRace'

  serialize :last_event, HashWithIndifferentAccess

  attr_accessor :league_id

  def self.ingest(event)
    event[:timestamp] = Time.zone.parse(event[:timestamp])
    instance.update(event.with_indifferent_access)
  end

  def self.associate_match(match)
    instance.associate_match(match)
  end

  def self.instance
    first_or_create
  end

  def update(next_event)
    case next_event[:event_type]
    when 'race_screen'         then capture_snapshot(next_event)
    when 'match_result_screen' then finalize_match(next_event)
    when 'main_menu_screen'    then abandon_match(next_event)
    when 'intro_screen'        then setup_race(next_event)
    when 'race_result_screen'  then finalize_race(next_event)
    when 'loading_screen'      then finalize_race({})
    else raise("Unknown event #{next_event.inspect}")
    end
    self.last_event = next_event
    save!
  end

  def associate_match(match)
    kartalytics_match = KartalyticsMatch.unassigned.where('created_at < ? AND created_at > ?', 5.minutes.ago, 6.hours.ago).order('created_at DESC').first

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
      current_match.update_attributes(player_count: event[:data].keys.length)
    end

    current_race.create_snapshot(event)
  end

  def finalize_match(event)
    # Already finalized
    return if current_match.nil?

    # Ensure we get a read that matches the player count
    return if event[:data].nil? || current_match.player_count != event[:data].keys.count { |key| key.include?('player') }

    current_match.finalize!(event)

    self.current_race = nil
    self.current_match = nil
  end

  def abandon_match(_event)
    return if current_match.nil?

    current_match.abandon!
    self.current_race = nil
    self.current_match = nil
  end

  def finalize_race(event)
    # Already finalized
    return if current_race.nil?
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

  def setup_race(intro_event)
    race_start_time = intro_event.fetch(:timestamp) + 10.seconds

    if current_race
      current_race.update_attributes(started_at: race_start_time)
    else
      ensure_match_exists!

      course = KartalyticsCourse.find_or_create_by(name: intro_event.fetch(:data).fetch(:course_name))
      self.current_race = KartalyticsRace.create!(match: current_match, course: course, started_at: race_start_time)
    end
  end

  private

  def ensure_race_exists!(timestamp)
    ensure_match_exists!
    return unless current_race.nil?

    # Bugger - must have missed the intro screen....
    course = KartalyticsCourse.find_or_create_by(name: 'Unknown Course')
    self.current_race = KartalyticsRace.create!(match: current_match, course: course, started_at: timestamp - 4.seconds)
  end

  def ensure_match_exists!
    self.current_match = KartalyticsMatch.create! if current_match.nil?
  end
end
