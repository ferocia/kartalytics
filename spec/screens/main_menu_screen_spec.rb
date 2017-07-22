require 'spec_helper'

describe MainMenuScreen do
  describe "matches_image?" do
    subject { described_class.matches_image?(screenshot) }

    context 'when not the main menu screen' do
      let(:screenshot) { Screenshot.new(fixture('match-result.jpg')) }

      it { is_expected.to be false }
    end

    context 'when the main menu screen' do
      let(:screenshot) { Screenshot.new(fixture('main-menu.jpg')) }

      it { is_expected.to be true }
    end
  end
end
