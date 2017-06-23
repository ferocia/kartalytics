require 'spec_helper'

describe Kartalytics::FinalResult do
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

  describe '#scores' do
    subject { final_result.scores }

    it { is_expected.to eql [47, 47, 44, 27, 25, 25, 23, 21, 21, 19, 19, 10] }
  end
end
