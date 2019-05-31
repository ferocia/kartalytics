require 'spec_helper'

describe IntroScreen do
  describe "matches_image?" do
    subject { described_class.matches_image?(screenshot) }

    context 'when not an intro screen' do
      let(:screenshot) { Screenshot.new(fixture('match-result.jpg')) }

      it { is_expected.to be false }
    end

    context 'when an intro screen' do
      let(:screenshot) { Screenshot.new(fixture('intro-screen.jpg')) }

      it { is_expected.to be true }
    end
  end

  describe "extract_event" do
    subject { described_class.extract_event(screenshot) }

    let(:screenshot) { Screenshot.new(fixture('intro-screen.jpg')) }

    it 'should extract the course name' do
      is_expected.to eq({
        event_type: 'intro_screen',
        data: {
          course_name: 'Yoshi Valley (N64)'
        }
      })
    end
  end
end
