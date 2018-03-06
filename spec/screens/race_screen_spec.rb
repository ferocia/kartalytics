require 'spec_helper'

describe RaceScreen do
  describe ".extract_event" do
    let(:image) { Screenshot.new(fixture('race1-6-nil-nil.jpg')) }

    subject { described_class.extract_event(image)[:data] }

    it 'should parse the player positions' do
      is_expected.to eq({
        player_one: {position: 1, item: "banana-triple"},
        player_two: {position: 6, item: "boomerang"}
      })
    end
  end
end
