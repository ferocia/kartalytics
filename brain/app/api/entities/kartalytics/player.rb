# frozen_string_literal: true

module Entities::Kartalytics
  # A simple representation of a Player. This should be cheap & fast to render,
  # expensive calls should be added to ComplexPlayer instead.
  class Player < Grape::Entity
    expose :id
    expose :name
    expose :image_url
    expose :retired?, as: :retired
  end
end
