# frozen_string_literal: true

module Resources
  class Leaderboard < Grape::API
    format :json

    params do
      requires :league_id, type: String
    end

    get '/' do
      present TrueskillLeaderboard.new(params[:league_id]).latest,
              with: Entities::TrueskillPlayer
    end
  end
end
