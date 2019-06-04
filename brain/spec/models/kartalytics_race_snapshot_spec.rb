require 'rails_helper'

describe KartalyticsRaceSnapshot, type: :model do

  describe ".series_for" do
    let!(:race) { FactoryBot.create :kartalytics_race }

    let!(:snapshots) {
      [
        FactoryBot.create(:kartalytics_race_snapshot, race: race, timestamp: 4.seconds.ago),
        FactoryBot.create(:kartalytics_race_snapshot, race: race, timestamp: 3.seconds.ago, player_two_position: 2, player_two_item: "green-shell"),
        FactoryBot.create(:kartalytics_race_snapshot, race: race, timestamp: 2.seconds.ago, player_two_position: 2, player_two_item: "green-shell"),
        FactoryBot.create(:kartalytics_race_snapshot, race: race, timestamp: 1.seconds.ago, player_three_item: "green-shell", player_three_position: 3)
      ]
    }

    subject { described_class.series_for(player) }

    context 'when the player has no position registered' do
      let(:player) { :player_one }
      it 'should return an empty array' do
        is_expected.to eq([])
      end
    end

    context 'when an item is detected across two frames' do
      let(:player) { :player_two }

      it 'should return the position and item' do
        expect(subject.map{ |snapshot|
          snapshot.except(:timestamp)
        }).to eq(
          [
            {position: 2, item: nil},
            {position: 2, item: "green-shell"},
            {position: 2, item: nil}
          ]
        )
      end
    end

    context 'when we have only seen one frame of the item' do
      let(:player) { :player_three }
      it 'should not return the item yet' do
        expect(subject.map{ |snapshot|
          snapshot.except(:timestamp)
        }).to eq(
          [
            {position: 3, item: nil},
            {position: 3, item: nil},
            {position: 3, item: nil},
            {position: 3, item: nil}
          ]
        )
      end
    end
  end
end
