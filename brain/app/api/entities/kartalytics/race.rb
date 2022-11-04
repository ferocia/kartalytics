# frozen_string_literal: true

module Entities::Kartalytics
  # A representation of a KartalyticsRace.
  class Race < Grape::Entity
    expose :id
    expose :course_name
    expose :course_image_url
    expose :chart

    private

    def course_name
      course.name
    end

    def course_image_url
      course.image
    end

    def chart
      object.to_chart_json(include_records: false)
    end

    def course
      @course ||= object.course
    end
  end
end
