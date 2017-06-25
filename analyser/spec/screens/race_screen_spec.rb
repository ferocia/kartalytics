require 'spec_helper'

describe RaceScreen do
  describe ".extract_postions" do
    let(:image) { fixture_image('race1-6-nil-nil.jpg') }

    subject { described_class.extract_postions(image) }

    it 'should parse the player positions' do
      is_expected.to eq({
        player_one: {position: 1},
        player_two: {position: 6}
      })
    end
  end
end
