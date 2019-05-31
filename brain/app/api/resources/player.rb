# frozen_string_literal: true

module Resources
  class Player < Grape::API
    format :json

    params do
      requires :league_id,  type: String
      requires :name,       type: String
    end
    get '/inspect' do
      begin
        ::InspectPlayer.new(params[:league_id], params[:name]).execute
      rescue InspectPlayer::MissingPlayerError => e
        status 404
        { error: "Player: '#{e}' doesn't exist" }
      end
    end

    params do
      requires :league_id,  type: String
      requires :name,       type: String
    end
    post 'new' do
      new_player = ::Player.new(name: params[:name])
      if new_player.save
        { result: 'ok', player: { name: new_player.name } }
      else
        status 400
        { error: new_player.errors.full_messages.join(', ') }
      end
    end
  end
end
