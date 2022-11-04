# frozen_string_literal: true

module Entities::Kartalytics
  # A simple representation of a KartalyticsMatch. This is used by Event, so
  # expensive calls should be avoided. These can be added to ComplexMatch.
  class Match < Grape::Entity
    expose :id
    expose :created_at
    expose :status
    expose :assigned?, as: :assigned
    expose :started?, as: :started
    expose :leaderboard

    private

    def match
      object
    end

    def leaderboard
      player_symbols = match.started? ? match.present_players : ::KartalyticsMatch::PLAYERS
      player_symbols.map do |player|
        {
          player: player,
          score: match.public_send("#{player}_score"),
          position: match.public_send("#{player}_position").to_i,
          color: ::KartalyticsRace.colour(player),
          name: match.public_send("#{player}_name"),
          image_url: match.public_send(player).try(:image_url),
          cumulative_race_scores: cumulative_race_scores_for(player),
        }
      end
    end

    def cumulative_race_scores_for(player)
      score_array = finished_races.reduce([0]) do |acc, race|
        acc.push(acc.last + (race.public_send("#{player}_score") || 0))
      end
    end

    def finished_races
      @finished_races ||= match.races.in_race_order.finished
    end
  end
end
