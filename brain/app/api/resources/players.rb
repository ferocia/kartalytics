# frozen_string_literal: true

module Resources
  class Players < Grape::API
    format :json

    params do
      requires :league_id, type: String
    end
    get '/' do
      present ::Leaderboard.new(params[:league_id]).latest,
              with: Entities::Player
    end
  end
end
