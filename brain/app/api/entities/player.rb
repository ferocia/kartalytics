# frozen_string_literal: true

module Entities
  # List all players
  class Player < Grape::Entity
    root 'players', 'player'
    expose :name
    expose :matches_played
    expose :streak

    format_with(:to_i, &:to_i)
    with_options(format_with: :to_i) do
      expose :score
      expose :rating
    end
  end
end
