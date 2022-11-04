# frozen_string_literal: true

module Entities
  # List all players
  class TrueskillPlayer < Grape::Entity
    root 'players', 'player'
    expose :name
    expose :matches_played
    expose :streak
    expose :extinguisher

    format_with(:reduced_precision) { |number| number ? number.round(3) : nil }
    with_options(format_with: :reduced_precision) do
      expose :score
      expose :score_change_last_match
    end
  end
end
