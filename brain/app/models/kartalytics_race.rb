# frozen_string_literal: true

require 'base64'

class KartalyticsRace < ApplicationRecord
  belongs_to :match, class_name: 'KartalyticsMatch', foreign_key: 'kartalytics_match_id'
  belongs_to :course, class_name: 'KartalyticsCourse', foreign_key: 'kartalytics_course_id'
  has_many :race_snapshots, class_name: 'KartalyticsRaceSnapshot', dependent: :destroy
  has_many :entered_races, foreign_key: 'race_id', dependent: :destroy

  scope :in_race_order, -> { order started_at: :asc }
  scope :finished, -> { where status: :finished }

  after_create :match_start_message

  validates :kartalytics_course_id, :kartalytics_match_id, :status, presence: true

  PLAYERS = %i[player_one player_two player_three player_four].freeze

  def finished?
    status == 'finished'
  end

  def any_players_finished?
    PLAYERS.any? { |player| public_send("#{player}_finished_at").present? }
  end

  def match_start_message
    return if match.races.count != 1
    return unless match.players_assigned?

    count_in_a_row = match.count_matches_in_a_row

    message = if count_in_a_row == 1
      "starting a game"
    else
      case count_in_a_row
      when 2
        "doubling down"
      when 3
        "tripling down"
      when 4
        "quadrupling down"
      when 5
        "quintupling down"
      when 6
        "sextupling down"
      when 7
        "septupling down"
      when 8
        "octupling down"
      when 9
        "nonupling down"
      when 10
        "decupling down"
      else
        "playing a #{count_in_a_row.ordinalize} game in a row"
      end
    end

    ::Slack.notify(":red_shell: #{match.player_names_in_order.join(' ')} are #{message} :green_shell:")
  end

  def race_time
    cached_best_time = best_time
    cached_best_time - started_at if finished? && cached_best_time
  end

  def update_course_info!(course_name:, image_base64: nil, **attributes)
    self.detected_courses[course_name] ||= 0
    self.detected_courses[course_name] = self.detected_courses[course_name] + 1
    course_name = detected_courses.max_by{|k,v| v }.first
    next_course = KartalyticsCourse.find_or_create_by(name: course_name)

    # avoid updating the detected image unless the course has changed.
    # this avoids storing a blank image as the intro fades out
    if course != next_course || course.unknown? || detected_image.nil?
      update_detected_image(image_base64) if image_base64.present?
    end

    update!(
      detected_courses: self.detected_courses,
      course: next_course,
      **attributes
    )
  end

  def update_course(course)
    update(course: course)
    entered_races.update_all(course_id: course.id)
  end

  def update_detected_image(image_base64)
    blob = Base64.strict_decode64(image_base64)
    update(detected_image: blob)
  rescue StandardError => e
    Rails.logger.error e.message
  end

  def detected_image_base64
    Base64.strict_encode64(detected_image) if detected_image.present?
  end

  def best_time
    PLAYERS.map { |player| public_send("#{player}_finished_at") }.compact.min
  end

  def players_in_order
    PLAYERS.sort_by do |player|
      [
        public_send("#{player}_finished_at") || Float::INFINITY,
        public_send("#{player}_position") || Float::INFINITY,
      ]
    end
  end

  def to_chart_json(include_records: true)
    {
      status: status,
      race_time: race_time,
      players: PLAYERS.map do |player|
        finished_at = public_send("#{player}_finished_at")

        if finished_at
          duration = finished_at - started_at
          delta = finished_at - best_time
          delta_formatted = "+#{delta.round(2)}s" if delta > 0
        end

        if finished_at && include_records
          player_instance = match.public_send(player)
          pb_set = course.pb_set_for?(player_instance, duration)
          pb_delta = course.pb_delta_for(player_instance, duration) if pb_set
          course_record_set = finished_at == best_time && course.record_set?(duration)
          course_record_delta = course.record_delta(duration) if course_record_set
        end

        {
          player:     player,
          label:      match.public_send("#{player}_name"),
          data:       race_snapshots.series_for(player),
          color:      KartalyticsRace.colour(player),
          delta:      delta_formatted,
          race_time:  duration,
          pb_set:     pb_set,
          pb_delta:   pb_delta,
          course_record_set: course_record_set,
          course_record_delta: course_record_delta,
        }
      end
    }
  end

  def self.colour(player)
    {
      player_one:   'rgb(254, 207, 0)',
      player_two:   'rgb(25, 191, 241)',
      player_three: 'rgb(224, 38, 67)',
      player_four:  'rgb(93, 251, 60)'
    }.fetch(player)
  end

  def create_snapshot(snapshot_event)
    data = snapshot_event.fetch(:data)

    attrs = { timestamp: snapshot_event.fetch(:timestamp) }

    PLAYERS.each do |player|
      attrs["#{player}_position"] = data.dig(player, 'position')
      attrs["#{player}_item"] = data.dig(player, 'item')
    end

    race_snapshots.create(attrs)

    store_if_players_finished(snapshot_event)
  end

  def store_if_players_finished(snapshot_event)
    data = snapshot_event.fetch(:data)
    PLAYERS.each do |player|
      if data[player] && data[player][:status] == 'finish'
        public_send("#{player}_finished_at=", public_send("#{player}_finished_at") || snapshot_event.fetch(:timestamp))
      end
    end
    save
  end

  def update_results!(results_event)
    return if finished?

    data = results_event.fetch(:data)
    update!(
      status:                'finished',
      player_one_position:   data[:player_one].try(:[], 'position'),
      player_two_position:   data[:player_two].try(:[], 'position'),
      player_three_position: data[:player_three].try(:[], 'position'),
      player_four_position:  data[:player_four].try(:[], 'position'),

      player_one_score:      data[:player_one].try(:[], 'points'),
      player_two_score:      data[:player_two].try(:[], 'points'),
      player_three_score:    data[:player_three].try(:[], 'points'),
      player_four_score:     data[:player_four].try(:[], 'points')
    )

    publish!
  end

  def publish!
    players_in_order.each do |player_symbol|
      finished_at = public_send("#{player_symbol}_finished_at")
      duration = finished_at.to_f - started_at.to_f
      player = match.public_send(player_symbol)

      next unless player.present? && course.record_set?(duration)

      delta = course.record_delta(duration)
      wr_delta = course.wr_delta(duration)
      message = [':sprakcle: NEW COURSE RECORD!']
      message << if course.champion.nil?
        "#{player.name} has set the record for #{course.name}"
      elsif player.id == course.champion.id
        "#{player.name} has improved their record on #{course.name}"
      else
        "#{player.name} has stolen #{course.name} from #{course.champion.name}"
      end
      message << "with a time of #{duration.round(3)}s"
      message << "(#{delta.round(3)}s)" if delta
      if wr_delta
        wr_delta_old = course.wr_delta(course.best_time)
        message << ":sprakcle:" unless delta
        message << "WR gap:"
        message << "#{wr_delta_old.round(3)}s :arrow_lower_right:" unless wr_delta_old.nil?
        message << "#{wr_delta.round(3)}s"
      end

      ::Slack.notify(message.join(' '))

      break
    end
  end
end
