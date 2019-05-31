# frozen_string_literal: true

module Entities
  # List all matches
  class Match < Grape::Entity
    root 'matches', 'match'

    expose :id
    expose :created_at
    expose :players_in_order
  end
end
