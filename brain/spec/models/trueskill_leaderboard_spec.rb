# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TrueskillLeaderboard, type: :model do
  describe 'position_for' do
    let!(:p1) { FactoryBot.create(:player, name: 'raf') }
    let!(:p2) { FactoryBot.create(:player, name: 'cookie') }
    let!(:p3) { FactoryBot.create(:player, name: 'roy') }
    let(:league) { FactoryBot.create(:league, id: 'jh75w7', name: 'pupper league') }
    let(:leaderboard) { TrueskillLeaderboard.new(league.id, 1.month.ago) }

    context 'without matches' do
      it 'returns nil' do
        expect(leaderboard.position_for(p1)).to be_nil
      end
    end

    context 'with matches' do
      before do
        FactoryBot.create(:match, league: league, players_in_order: 'cookie,roy,raf')
        FactoryBot.create(:match, league: league, players_in_order: 'roy,cookie,raf')
        FactoryBot.create(:match, league: league, players_in_order: 'raf,cookie,roy')
      end

      it 'returns player position on the leaderboard' do
        expect(leaderboard.position_for(p1)).to eq(3)
        expect(leaderboard.position_for(p2)).to eq(1)
        expect(leaderboard.position_for(p3)).to eq(2)
      end
    end
  end
end
