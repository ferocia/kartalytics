require 'rails_helper'

RSpec.describe League, type: :model do
  describe '.id_for' do
    it 'returns nil when name does not exist' do
      expect(League.id_for("bogus")).to eq(nil)
    end
  end
end
