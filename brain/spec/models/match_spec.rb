# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Match, type: :model do
  describe 'destroy' do
    let(:kartalytics_match) { FactoryBot.create(:kartalytics_match) }
    let(:match) { FactoryBot.create(:match, kartalytics_match: kartalytics_match) }

    before do
      match.destroy
    end

    it 'unassociates the match from the kartalytics match' do
      expect(kartalytics_match.match_id).to be_nil
    end
  end
end
