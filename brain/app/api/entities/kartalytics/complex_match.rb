# frozen_string_literal: true

module Entities::Kartalytics
  # A detailed representation of a KartalyticsMatch, used for the
  # /kartalytics_matches/:id route
  class ComplexMatch < Entities::Kartalytics::Match
    expose :races, with: Entities::Kartalytics::Race

    def races
      object.races.in_race_order
    end
  end
end
