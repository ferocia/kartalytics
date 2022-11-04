# frozen_string_literal: true

require 'rails_helper'
describe 'Players API', type: :request do
  context 'league ABC' do
    before do
      get '/api/players', params: { league_id: 'ABC' }
    end
    specify do
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['players'].length).to eq(2)
    end
  end

  context 'league 123' do
    before do
      get '/api/players', params: { league_id: '123' }
    end
    specify do
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['players'].length).to eq(5)
      expect(json['players'][0]['name']).to eq('chris')
      expect(json['players'][0]['matches_played']).to eq(4)
      expect(json['players'][0]['streak']).to eq(4)
      expect(json['players'][0]['rating']).to eq(84)
      expect(json['players'][0]['score']).to eq(82)

      expect(json['players'][1]['name']).to eq('raj')
      expect(json['players'][1]['matches_played']).to eq(3)
      expect(json['players'][1]['streak']).to eq(0)
      expect(json['players'][1]['rating']).to eq(-33)
      expect(json['players'][1]['score']).to eq(12)

      expect(json['players'][2]['name']).to eq('mike')
      expect(json['players'][2]['matches_played']).to eq(1)
      expect(json['players'][2]['streak']).to eq(0)
      expect(json['players'][2]['rating']).to eq(8)
      expect(json['players'][2]['score']).to eq(8)

      expect(json['players'][3]['name']).to eq('tom')
      expect(json['players'][3]['matches_played']).to eq(4)
      expect(json['players'][3]['streak']).to eq(0)
      expect(json['players'][3]['rating']).to eq(-13)
      expect(json['players'][3]['score']).to eq(0)

      expect(json['players'][4]['name']).to eq('gt')
      expect(json['players'][4]['matches_played']).to eq(4)
      expect(json['players'][4]['streak']).to eq(0)
      expect(json['players'][4]['rating']).to eq(-45)
      expect(json['players'][4]['score']).to eq(0)
    end
  end

  context 'multiple streaks' do
    before do
      Match.create_for!('123', %w[mike tom])
      Match.create_for!('123', %w[mike tom])
    end

    specify do
      get '/api/players', params: { league_id: '123' }
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['players'][0]['streak']).to eq(4)
      expect(json['players'][1]['streak']).to eq(2)
    end
  end
  context 'when there are no matches in the league' do
    before do
      get '/api/players', params: { league_id: 'XYZ' }
    end
    it 'returns no players' do
      expect(response).to be_successful
      json = JSON.parse(response.body)
      expect(json['players'].length).to eq(0)
    end
  end
end
