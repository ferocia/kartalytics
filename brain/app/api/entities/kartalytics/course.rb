# frozen_string_literal: true

module Entities::Kartalytics
  # A simple representation of a Course. This should be cheap & fast to render,
  # expensive calls should be added to ComplexCourse instead.
  class Course < Grape::Entity
    expose :id
    expose :name
    expose :image
    expose :champion, with: Entities::Kartalytics::Player
  end
end
