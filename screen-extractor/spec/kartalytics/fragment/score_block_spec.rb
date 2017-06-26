require 'spec_helper'

describe Kartalytics::Fragment::ScoreBlock do
  let(:score_block) { described_class.new(image) }

  describe '#to_i' do
    subject { score_block.to_i }

    context 'standard block' do
      let(:image) { fixture 'images/score_block1.jpg' }
      it { is_expected.to eql 47 }
    end

    context 'yellow block' do
      let(:image) { fixture 'images/score_block2.jpg' }
      it { is_expected.to eql 19 }
    end

    context 'blue block' do
      let(:image) { fixture 'images/score_block3.jpg' }
      it { is_expected.to eql 10 }
    end

    context 'red block' do
      let(:image) { fixture 'images/score_block4.jpg' }

      it 'returns correct value' do
        is_expected.to eql 19
      end
    end
  end
end
