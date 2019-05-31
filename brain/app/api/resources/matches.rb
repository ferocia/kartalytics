# frozen_string_literal: true

module Resources
  class Matches < Grape::API
    format :json

    params do
      requires :league_id, type: String
    end
    get '/' do
      present Match.where(league_id: params[:league_id]),
              with: Entities::Match
    end
  end
end
