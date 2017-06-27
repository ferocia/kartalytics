require 'spec_helper'

describe Kartalytics::Scene::FinalResult do
  let(:image) { fixture 'images/final_result.jpg' }
  let(:final_result) { described_class.new(image) }

  describe '#image' do
    subject { final_result.image }

    it { is_expected.not_to eql nil }

    it 'is an image' do
      expect(subject.class).to eql Magick::Image
    end

    it 'has expected dimensions' do
      expect(subject.columns).to eql 1280
      expect(subject.rows).to eql 720
    end
  end
end
