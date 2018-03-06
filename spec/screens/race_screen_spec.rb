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

    context 'when all players have items' do
      let(:image) { Screenshot.new(fixture('race-items.jpg')) }

      it 'should detect the items' do
        is_expected.to eq({
          :player_four => {:position=>1, :item=>"banana"},
          :player_one => {:position=>7, :item=>"fire-flower"},
          :player_three => {:position=>3, :item=>"green-shell"},
          :player_two => {:position=>10, :item=>"green-shell"}
        })
      end
    end
  end
end
