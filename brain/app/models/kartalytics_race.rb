# frozen_string_literal: true

class KartalyticsRace < ApplicationRecord
  belongs_to :match, class_name: 'KartalyticsMatch', foreign_key: 'kartalytics_match_id'
  belongs_to :course, class_name: 'KartalyticsCourse', foreign_key: 'kartalytics_course_id'
  has_many :race_snapshots, class_name: 'KartalyticsRaceSnapshot'

  PLAYERS = %i[player_one player_two player_three player_four].freeze

  def finished?
    status == 'finished'
  end

  def race_time
    cached_best_time = best_time
    cached_best_time - started_at if finished? && cached_best_time
  end

  def best_time
    PLAYERS.map { |player| public_send("#{player}_finished_at") }.compact.min
  end

  def to_chart_json
    first_time = best_time if finished?

    {
      status: status,
      players: PLAYERS.map do |player|
        finished_at = public_send("#{player}_finished_at")

        if finished? && finished_at
          if best_time == finished_at
            finished_at = "#{(finished_at - started_at).round(1)}s"
          else
            finished_at = "+#{(finished_at - best_time).round(1)}s"
          end
        end

        {
          player:     player,
          label:      match.public_send("#{player}_name"),
          data:       race_snapshots.series_for(player),
          color:      KartalyticsRace.colour(player),
          finishedAt: finished? ? finished_at : nil
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

        course.store_best_time(best_time - started_at)
      end
    end
    save
  end

  def update_results!(results_event)
    data = results_event.fetch(:data)
    update_attributes!(status:                'finished',
                       player_one_position:   data[:player_one].try(:[], 'position'),
                       player_two_position:   data[:player_two].try(:[], 'position'),
                       player_three_position: data[:player_three].try(:[], 'position'),
                       player_four_position:  data[:player_four].try(:[], 'position'),

                       player_one_score:      data[:player_one].try(:[], 'points'),
                       player_two_score:      data[:player_two].try(:[], 'points'),
                       player_three_score:    data[:player_three].try(:[], 'points'),
                       player_four_score:     data[:player_four].try(:[], 'points'))
  end
end
