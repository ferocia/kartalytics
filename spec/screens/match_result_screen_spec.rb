require 'spec_helper'

describe MatchResultScreen do
  describe ".extract_event" do
    let(:screenshot) { Screenshot.new(fixture('match-result.jpg')) }

    subject { described_class.extract_event(screenshot)[:data] }

    it 'should extract all player positions correctly' do
      is_expected.to eq({
        speed: '150cc',
        player_one: {position: 8},
        player_three: {position: 9},
        player_two: {position: 11},
        player_four: {position: 4}
      })
    end
  end

  describe 'matches_image?' do
    subject { described_class.matches_image?(screenshot) }

    context 'for 150cc' do
      let(:screenshot) { Screenshot.new(fixture('match-result.jpg')) }

      it { is_expected.to be true }
    end

    context 'for 200cc' do
      let(:screenshot) { Screenshot.new(fixture('match-result200cc.jpg')) }

      it { is_expected.to be true }
    end
  end
end
