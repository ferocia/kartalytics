# frozen_string_literal: true

require 'rails_helper'
describe 'Players API', type: :request do
  context 'league ABC' do
    before do
      get '/api/matches', params: { league_id: 'ABC' }
    end
    specify do
      expect(response).to be_success
      json = JSON.parse(response.body)
      expect(json['matches'].length).to eq(3)
    end
  end
end
