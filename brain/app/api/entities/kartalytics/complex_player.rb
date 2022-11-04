# frozen_string_literal: true

module Entities::Kartalytics
  # A detailed representation of a Player, used for the /player/:name route.
  class ComplexPlayer < Entities::Kartalytics::Player
    expose :average_score
    expose :courses, with: Entities::Kartalytics::Course
    expose :leaderboard_position
    expose :number_of_matches
    expose :on_fire?, as: :on_fire
    expose :perfect_matches
    expose :recent_matches, with: Entities::Kartalytics::Match
    expose :recent_scores
    expose :rival_results
    expose :course_records

    private

    def leaderboard_position
      object.leaderboard_position(League.id_for('kart'), 1.month.ago)
    end

    def recent_scores
      object.recent_scores(limit: 30)
    end

    def rival_results
      object.rival_results(League.id_for('kart'))
    end

    def perfect_matches
      object.perfect_matches.size
    end

    def course_records
      object.course_records.size
    end
  end
end
