# frozen_string_literal: true

require 'rails_helper'

describe 'Kartalytics API', type: :request do
  context 'regular match' do
    specify do
      get '/api/kartalytics/event'
      expect(response).to be_successful
      json = JSON.parse(response.body)

      expect(json['match']['status']).to eq('finished')

      expect(json['match']['leaderboard'].length).to eq(4)

      player_one = json['match']['leaderboard'][1]
      player_two = json['match']['leaderboard'][2]
      player_three = json['match']['leaderboard'][3]
      player_four = json['match']['leaderboard'][0]

      expect(player_one['player']).to eq('player_one')
      expect(player_two['player']).to eq('player_two')
      expect(player_three['player']).to eq('player_three')
      expect(player_four['player']).to eq('player_four')

      expect(player_one['score']).to eq(10)
      expect(player_two['score']).to eq(9)
      expect(player_three['score']).to eq(9)
      expect(player_four['score']).to eq(42)

      expect(player_one['position']).to eq(4)
      expect(player_two['position']).to eq(6)
      expect(player_three['position']).to eq(7)
      expect(player_four['position']).to eq(2)

      expect(player_one['cumulative_race_scores'].length).to eq(3)
      expect(player_two['cumulative_race_scores'].length).to eq(3)
      expect(player_three['cumulative_race_scores'].length).to eq(3)
      expect(player_four['cumulative_race_scores'].length).to eq(3)

      expect(player_one['cumulative_race_scores'][0]).to eq(0)
      expect(player_two['cumulative_race_scores'][0]).to eq(0)
      expect(player_three['cumulative_race_scores'][0]).to eq(0)
      expect(player_four['cumulative_race_scores'][0]).to eq(0)

      expect(player_one['cumulative_race_scores'][1]).to eq(2)
      expect(player_two['cumulative_race_scores'][1]).to eq(5)
      expect(player_three['cumulative_race_scores'][1]).to eq(8)
      expect(player_four['cumulative_race_scores'][1]).to eq(13)

      expect(player_one['cumulative_race_scores'][2]).to eq(17)
      expect(player_two['cumulative_race_scores'][2]).to eq(17)
      expect(player_three['cumulative_race_scores'][2]).to eq(17)
      expect(player_four['cumulative_race_scores'][2]).to eq(14)

      expect(json['race']['status']).to eq('in_progress')
      expect(json['race']['players'].length).to eq(4)
    end
  end

  context 'unassigned players' do
    before do
      kartalytics_match = FactoryBot.create(:kartalytics_match, status: 'in_progress')
    end

    it 'returns all players when unassigned' do
      get '/api/kartalytics/event'
      expect(response).to be_successful
      json = JSON.parse(response.body)

      expect(json['match']['leaderboard'].length).to eq(4)
    end
  end

  context '< 4 players assigned' do
    before do
      kartalytics_match = FactoryBot.create(:kartalytics_match, status: 'in_progress', player_count: 3)
      FactoryBot.create(:kartalytics_race, match: kartalytics_match)

      kartalytics_match.associate_players!({
        player_one: FactoryBot.create(:player, name: 'assigned_1'),
        player_two: FactoryBot.create(:player, name: 'assigned_2'),
        player_three: FactoryBot.create(:player, name: 'assigned_3'),
      })
    end

    it 'generates a shorter leaderboard' do
      get '/api/kartalytics/event'
      expect(response).to be_successful
      json = JSON.parse(response.body)

      expect(json['match']['status']).to eq('in_progress')

      expect(json['match']['leaderboard'].length).to eq(3)

      player_one = json['match']['leaderboard'][0]
      player_two = json['match']['leaderboard'][1]
      player_three = json['match']['leaderboard'][2]

      expect(player_one['name']).to eq('Assigned 1')
      expect(player_two['name']).to eq('Assigned 2')
      expect(player_three['name']).to eq('Assigned 3')
    end
  end

  describe '/double-down' do
    let(:player_one) { FactoryBot.create(:player, name: 'assigned_1') }
    let(:player_two) { FactoryBot.create(:player, name: 'assigned_2') }
    let(:player_three) { FactoryBot.create(:player, name: 'assigned_3') }

    before do
      previous_match = FactoryBot.create(
        :kartalytics_match,
        status: 'finished',
        player_one: player_one,
        player_two: player_two,
        player_three: player_three,
      )
    end

    it 'assigns players from the previous match' do
      current_match = FactoryBot.create(:kartalytics_match)
      expect(current_match.player_one).to be_nil
      expect(current_match.player_two).to be_nil
      expect(current_match.player_three).to be_nil
      expect(current_match.player_four).to be_nil

      put '/api/kartalytics/double-down'
      expect(response).to be_successful

      current_match.reload
      expect(current_match.player_one).to eq(player_one)
      expect(current_match.player_two).to eq(player_two)
      expect(current_match.player_three).to eq(player_three)
      expect(current_match.player_four).to be_nil
    end
  end
end
