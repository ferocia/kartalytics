require 'spec_helper'

describe MatchResultScreen do
  describe ".extract_event" do
    context 'for 150cc' do
      let(:screenshot) { Screenshot.new(fixture('match-result.jpg')) }

      subject { described_class.extract_event(screenshot)[:data] }

      it 'extracts all player positions and scores correctly' do
        is_expected.to eq({
          speed: '150cc',
          player_one: { position: 8, score: 21 },
          player_three: { position: 9, score: 21 },
          player_two: { position: 11, score: 16 },
          player_four: { position: 4, score: 23 },
        })
      end
    end

    context 'for 200cc' do
      let(:screenshot) { Screenshot.new(fixture('match-result200cc.jpg')) }

      subject { described_class.extract_event(screenshot)[:data] }

      it 'extracts all player positions and scores correctly' do
        is_expected.to eq({
          speed: '200cc',
          player_one: { position: 1, score: 68 },
          player_three: { position: 2, score: 68 },
          player_two: { position: 3, score: 64 },
          player_four: { position: 4, score: 60 },
        })
      end
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
