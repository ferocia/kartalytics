# frozen_string_literal: true

class EnteredMatch < ApplicationRecord
  belongs_to :player
  belongs_to :kartalytics_match
end
