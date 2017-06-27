require 'spec_helper'

describe Kartalytics::Scene::Result do
  let(:result_scene) { described_class.new(image) }

  describe '#characters' do
    subject { result_scene.characters }

    context 'result 1' do
      let(:image) { fixture 'images/result1.jpg' }

      it do
        is_expected.to eql %i[black_yoshi lakitu tanooki_mario baby_luigi inkling_girl rosalina mario dry_bowser
                              baby_rosalina donkey_kong white_yoshi light_blue_yoshi]
      end
    end

    context 'result 2' do
      let(:image) { fixture 'images/result2.jpg' }

      it do
        is_expected.to eql %i[lakitu baby_luigi tanooki_mario inkling_girl baby_rosalina dry_bowser
                              donkey_kong mario rosalina white_yoshi black_yoshi light_blue_yoshi]
      end
    end
  end
end
