require 'spec_helper'
require 'base64'

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
    let(:image_base64) { Base64.strict_encode64(described_class.prepare_image(screenshot).to_blob) }

    it 'should extract the course name' do
      is_expected.to eq({
        event_type: 'intro_screen',
        data: {
          course_name: 'Yoshi Valley (N64)',
          image_base64: image_base64,
        }
      })
    end

    context 'when a rainbow road n64' do
      let(:screenshot) { Screenshot.new(fixture('intro-screen-rainbow-n64.jpg')) }

      it 'should extract the correct course name' do
        is_expected.to eq({
          event_type: 'intro_screen',
          data: {
            course_name: 'Rainbow Road (N64)',
            image_base64: image_base64,
          }
        })
      end
    end

    context 'when the course name cannot be detected' do
      let(:screenshot) { Screenshot.new(fixture('intro-screen-pre-text.jpg')) }

      it 'returns an Unknown Course event' do
        is_expected.to eq({
          event_type: 'intro_screen',
          data: {
            course_name: 'Unknown Course',
            image_base64: image_base64,
          }
        })
      end
    end
  end
end
