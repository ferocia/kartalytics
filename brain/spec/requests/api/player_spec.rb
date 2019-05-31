# frozen_string_literal: true

require 'rails_helper'

describe 'Player API', type: :request do
  describe 'create new player' do
    context 'successful' do
      before do
        expect(Player.where(name: 'trev').count).to eq(0)
        post '/api/player/new', params: { league_id: '123', name: 'trev' }
      end

      specify do
        expect(response).to be_success
        json = JSON.parse(response.body)
        expect(json['result']).to eq('ok')
        player = json['player']
        expect(player['name']).to eq('trev')
        expect(Player.where(name: 'trev').count).to eq(1)
      end
    end

    context 'with errors' do
      describe 'player already exists' do
        before do
          post '/api/player/new', params: { league_id: '123', name: 'mike' }
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq('Name has already been taken')
        end
      end

      context 'with missing required parameters' do
        before do
          post '/api/player/new'
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq('league_id is missing, name is missing')
        end
      end
    end
  end

  describe 'inspect player' do
    context 'successful' do
      before do
        get '/api/player/inspect', params: { league_id: '123', name: 'tom' }
      end

      specify do
        expect(response).to be_success
        json = JSON.parse(response.body)

        expect(json).to eq(
          'gt'    => { 'wins' => 3, 'losses' => 1, 'mojo' => 2 },
          'raj'   => { 'wins' => 2, 'losses' => 1, 'mojo' => 1 },
          'mike'  => { 'wins' => 0, 'losses' => 1, 'mojo' => -1 },
          'chris' => { 'wins' => 0, 'losses' => 4, 'mojo' => -4 }
        )
      end
    end

    context 'with errors' do
      describe 'player not found' do
        before do
          get '/api/player/inspect', params: { league_id: '123', name: 'bilbo' }
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq("Player: 'bilbo' doesn't exist")
        end
      end

      context 'with missing required parameters' do
        before do
          get '/api/player/inspect'
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq('league_id is missing, name is missing')
        end
      end
    end
  end
end
