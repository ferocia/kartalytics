require 'spec_helper'

describe Kartalytics::Digit do
  let(:digit) { described_class.new(image) }

  let(:zero) { fixture 'images/digit0.jpg' }
  let(:one) { fixture 'images/digit1.jpg' }
  let(:two) { fixture 'images/digit2.jpg' }
  let(:three) { fixture 'images/digit3.jpg' }
  let(:four) { fixture 'images/digit4.jpg' }
  let(:five) { fixture 'images/digit5.jpg' }
  let(:seven) { fixture 'images/digit7.jpg' }
  let(:nine) { fixture 'images/digit9.jpg' }

  describe '#to_i' do
    subject { digit.to_i }

    context '0' do
      let(:image) { zero }
      it { is_expected.to eql 0 }
    end

    context '1' do
      let(:image) { one }
      it { is_expected.to eql 1 }
    end

    context '2' do
      let(:image) { two }
      it { is_expected.to eql 2 }
    end

    context '3' do
      let(:image) { three }
      it { is_expected.to eql 3 }
    end


    context '4' do
      let(:image) { four }
      it { is_expected.to eql 4 }
    end


    context '5' do
      let(:image) { five }
      it { is_expected.to eql 5 }
    end

    context '7' do
      let(:image) { seven }
      it { is_expected.to eql 7 }
    end

    context '9' do
      let(:image) { nine }
      it { pending; is_expected.to eql 9 }
    end
  end

  describe '#zero?', focus: true do
    subject { digit.zero? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql true }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#one?', focus: true do
    subject { digit.one? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql true }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#two?', focus: true do
    subject { digit.two? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql true }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#three?', focus: true do
    subject { digit.three? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql true }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#four?', focus: true do
    subject { digit.four? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql true }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#five?', focus: true do
    subject { digit.five? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql true }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#seven?', focus: true do
    subject { digit.seven? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql true }
    end

    context 'nine' do
      let(:image) { nine }
      it { is_expected.to eql false }
    end
  end

  describe '#nine?', focus: true do
    subject { digit.nine? }

    context 'zero' do
      let(:image) { zero }
      it { is_expected.to eql false }
    end

    context 'one' do
      let(:image) { one }
      it { is_expected.to eql false }
    end

    context 'two' do
      let(:image) { two }
      it { is_expected.to eql false }
    end

    context 'three' do
      let(:image) { three }
      it { is_expected.to eql false }
    end

    context 'four' do
      let(:image) { four }
      it { is_expected.to eql false }
    end

    context 'five' do
      let(:image) { five }
      it { is_expected.to eql false }
    end

    context 'seven' do
      let(:image) { seven }
      it { is_expected.to eql false }
    end

    context 'nine' do
      let(:image) { nine }
      it { pending; is_expected.to eql true }
    end
  end
end
