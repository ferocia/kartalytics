# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'validations' do
    it { should validate_uniqueness_of(:name).case_insensitive }
  end
end
