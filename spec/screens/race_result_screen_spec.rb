require 'spec_helper'

describe RaceResultScreen do
  describe ".parse_results" do
    let(:image) { fixture_image('result-colors.png').get_pixels(0, 0, 1, 49) }

    subject { described_class.get_player_positions(image) }

    it 'should parse the player positions' do
      is_expected.to eq({
        player_one: {position: 3},
        player_two: {position: 4},
        player_three: {position: 2}
      })
    end
  end

  describe ".extract_event" do
    let(:screenshot) { Screenshot.new(fixture('four-player-race-result.jpg')) }

    subject { described_class.extract_event(screenshot)[:data] }

    it 'should extract all player positions correctly' do
      is_expected.to eq({
        player_one: {position: 11, points: 2},
        player_three: {position: 12, points: 1},
        player_two: {position: 5, points: 8},
        player_four: {position: 1, points: 15}
      })
    end
  end
end
