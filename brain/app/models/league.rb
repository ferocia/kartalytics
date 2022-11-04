# frozen_string_literal: true

class League < ApplicationRecord
  has_many :matches
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  before_create :generate_id

  def self.id_for(name)
    find_by(name: name)&.id
  end

  private

  def generate_id
    self.id ||= SecureRandom.hex(12)
  end
end
