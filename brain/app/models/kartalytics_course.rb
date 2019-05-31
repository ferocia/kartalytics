# frozen_string_literal: true

class KartalyticsCourse < ApplicationRecord
  has_many :races, class_name: 'KartalyticsRace'

  def image
    file_name = "courses/#{name.parameterize.underscore}.jpg"
    ActionController::Base.helpers.asset_path(file_name)
  end

  def store_best_time(new_time)
    return if new_time < 30

    if best_time.nil? || new_time < best_time
      update_attributes(best_time: new_time)
    end
  end
end
