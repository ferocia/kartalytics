# frozen_string_literal: true

require 'rails_helper'

describe 'Result API', type: :request do
  #  include Rack::Test::Methods

  describe 'result' do
    context 'creating new' do
      context 'successfully' do
        before do
          expect(::Slack).to receive(:notify).once
          post '/api/result', params: { league_id: '123', match_result: 'mike tom' }
        end

        specify do
          expect(response).to be_success
          json = JSON.parse(response.body)
          players = json['players']
          expect(players.count).to eq(5)

          chris = players[0]
          expect(chris['name']).to eq('chris')
          expect(chris['matches_played']).to eq(4)
          expect(chris['streak']).to eq(4)
          expect(chris['score']).to eq(24_733.563)
          expect(chris['score_change_last_match']).to eq(nil)

          mike = players[1]
          expect(mike['name']).to eq('mike')
          expect(mike['matches_played']).to eq(2)
          expect(mike['streak']).to eq(1)
          expect(mike['score']).to eq(16_050.885)
          expect(mike['score_change_last_match']).to eq(3423.773)

          tom = players[2]
          expect(tom['name']).to eq('tom')
          expect(tom['matches_played']).to eq(5)
          expect(tom['streak']).to eq(0)
          expect(tom['score']).to eq(13_433.683)
          expect(tom['score_change_last_match']).to eq(-254.835)

          raj = players[3]
          expect(raj['name']).to eq('raj')
          expect(raj['matches_played']).to eq(3)
          expect(raj['streak']).to eq(0)
          expect(raj['score']).to eq(8955.663)
          expect(raj['score_change_last_match']).to eq(nil)

          gt = players[4]
          expect(gt['name']).to eq('gt')
          expect(gt['matches_played']).to eq(4)
          expect(gt['streak']).to eq(0)
          expect(gt['score']).to eq(7988.855)
          expect(gt['score_change_last_match']).to eq(nil)
        end
      end

      describe 'result with invalid player' do
        before do
          expect(::Slack).not_to receive(:notify)
          post '/api/result', params: { league_id: '123', match_result: 'mike trev' }
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq("Unknown player: 'trev'")
        end
      end

      context 'result with duplicate player' do
        before do
          expect(::Slack).not_to receive(:notify)
          post '/api/result', params: { league_id: '123', match_result: 'mike mike' }
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq('No duplicates')
        end
      end

      context 'result with missing required parameters' do
        before do
          expect(::Slack).not_to receive(:notify)
          post '/api/result'
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq('league_id is missing, match_result is missing')
        end
      end
    end
  end

  context 'undo latest match' do
    context 'successfully' do
      let(:league_id)   { '123' }
      let(:last_match)  { Match.where(league_id: league_id).last }
      before do
        @original_count = Match.count
        expect(last_match).to be_present
        expect(::Slack).to receive(:notify).once
        delete '/api/result/undo_latest', params: { league_id: league_id }
      end

      specify do
        expect(response).to be_success
        expect(Match.count).to eq(@original_count - 1)

        json = JSON.parse(response.body)
        expect(json['result']).to eq('ok')
        expect(json['match']).to eq(last_match.players_in_order)
      end
    end
    context 'with errors' do
      context 'when no matches exists' do
        before do
          Match.delete_all
          expect(Match.last).not_to be_present
          expect(::Slack).not_to receive(:notify)
          delete '/api/result/undo_latest', params: { league_id: '123' }
        end

        specify do
          expect(response).not_to be_success
          json = JSON.parse(response.body)
          expect(json['error']).to eq('No matches to undo')
        end
      end

      context 'with missing required parameters' do
        before do
          expect(::Slack).not_to receive(:notify)
          delete '/api/result/undo_latest'
        end

        specify do
          expect(response).not_to be_success

          json = JSON.parse(response.body)
          expect(json['error']).to eq('league_id is missing')
        end
      end
    end
  end
end
