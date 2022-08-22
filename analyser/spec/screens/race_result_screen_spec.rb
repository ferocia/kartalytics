require 'spec_helper'

describe RaceResultScreen do
  describe '.matches_image?' do
    subject { described_class.matches_image?(screenshot) }

    context 'before the positions have animated' do
      let(:screenshot) { Screenshot.new(fixture('four-player-race-result-before-anim.jpg')) }

      it { is_expected.to be true }
    end

    context 'after the positions have animated' do
      let(:screenshot) { Screenshot.new(fixture('four-player-race-result-after-anim.jpg')) }

      it { is_expected.to be false }
    end

    context 'when not the race result screen' do
      let(:screenshot) { Screenshot.new(fixture('match-result.jpg')) }

      it { is_expected.to be nil }
    end
  end

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
    let(:screenshot) { Screenshot.new(fixture('four-player-race-result-before-anim.jpg')) }

    subject { described_class.extract_event(screenshot)[:data] }

    it 'should extract all player positions correctly' do
      is_expected.to eq({
        player_four: { position: 6, points: 7 },
        player_one: { position: 3, points: 10 },
        player_three: { position: 2, points: 12 },
        player_two: { position: 7, points: 6 },
      })
    end

    context 'for a three player game' do
      let(:screenshot) { Screenshot.new(fixture('three-player-race-result-before-anim.jpg')) }

      it 'extracts all player positions' do
        is_expected.to eq({
          player_two: { position: 7, points: 6 },
          player_three: { position: 11, points: 2 },
          player_one: { position: 12, points: 1 },
        })
      end
    end
  end
end
