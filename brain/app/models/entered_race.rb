# frozen_string_literal: true

class EnteredRace < ApplicationRecord
  belongs_to :player
  belongs_to :race, class_name: 'KartalyticsRace'
  belongs_to :course, class_name: 'KartalyticsCourse'
  belongs_to :kartalytics_match

  validates :player_id, :race_id, :course_id, :kartalytics_match_id, presence: true

  scope :ordered_by_race_time, -> { where('race_time IS NOT NULL').order('race_time ASC, race_id ASC, final_position ASC') }

  def self.fastest_races_per_course
    q = joins(
      <<-SQL
        INNER JOIN (
          SELECT course_id, MIN(race_time) min_time
          FROM entered_races
          WHERE race_time > 0
          GROUP BY course_id
        ) t2 ON t2.course_id = entered_races.course_id
        WHERE t2.min_time = entered_races.race_time
      SQL
    ).order('course_id, race_id ASC, final_position ASC')
      .includes(:course, :player)
      .uniq(&:course_id)
      .reject { |r| r.course.unknown? }
  end
end
