# frozen_string_literal: true

module Entities::Kartalytics
  # A detailed representation of a KartalyticsCourse, used for the
  # /courses/:id route
  class ComplexCourse < Entities::Kartalytics::Course
    expose :best_time
    expose :top_records
    expose :uniq_top_records
    expose :top_players

    def top_records
      object.top_records(limit: 20)
    end

    def uniq_top_records
      object.top_records(limit: 20, uniq: true)
    end

    def top_players
      object.top_players(limit: 20)
    end
  end
end
