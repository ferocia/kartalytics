# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnteredRace, type: :model do
  describe 'fastest_races_per_course' do
    let(:p1) { FactoryBot.create(:player, name: 'p1') }
    let(:p2) { FactoryBot.create(:player, name: 'p2') }
    let(:c1) { FactoryBot.create(:kartalytics_course) }
    let(:c2) { FactoryBot.create(:kartalytics_course) }
    let(:c3) { FactoryBot.create(:kartalytics_course, name: 'Unknown Course') }

    before do
      FactoryBot.create(:entered_race, course: c1, player: p1, race_time: 40)
      FactoryBot.create(:entered_race, course: c1, player: p2, race_time: 40)
      FactoryBot.create(:entered_race, course: c2, player: p1, race_time: 42)
      FactoryBot.create(:entered_race, course: c2, player: p2, race_time: 39)
      FactoryBot.create(:entered_race, course: c3, player: p1, race_time: 53)
    end

    it 'should return the fastest race for each course' do
      results = described_class.fastest_races_per_course

      expect(results.length).to eq(2)

      # expect(results[0].player).to eq(p1) does not work because of Comparable on Player
      expect(results[0].player.name).to eq('p1')
      expect(results[0].race_time).to eq(40)

      expect(results[1].player.name).to eq('p2')
      expect(results[1].race_time).to eq(39)
    end
  end

  describe 'ordered_by_race_time' do
    let(:player_one) { FactoryBot.create(:player, name: 'player one') }
    let(:player_two) { FactoryBot.create(:player, name: 'player two') }
    let(:course) { FactoryBot.create(:kartalytics_course) }
    let(:race) { FactoryBot.create(:kartalytics_race, course: course) }

    it 'orders the results by race_time, race_id, then final_position' do
      entered_race_1 = FactoryBot.create(:entered_race, course: course, race: race, player: player_one, race_time: 40, final_position: 2)
      entered_race_2 = FactoryBot.create(:entered_race, course: course, race: race, player: player_two, race_time: 40, final_position: 1)

      expect(described_class.ordered_by_race_time).to eq([entered_race_2, entered_race_1])
    end
  end
end
