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
end
