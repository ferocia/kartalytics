# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe '.find_by_mention' do
    subject { Player.find_by_mention(mention) }

    let!(:player) { FactoryBot.create(:player, name: 'linus', slack_id: 'U420') }

    context 'when given a name' do
      let(:mention) { 'linus' }

      it { is_expected.to eq(player) }
    end

    context 'when given a slack mention' do
      let(:mention) { '<@U420>' }

      it { is_expected.to eq(player) }
    end
  end
end
