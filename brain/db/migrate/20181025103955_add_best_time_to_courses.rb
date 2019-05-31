class AddBestTimeToCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :kartalytics_courses, :best_time, :float

    KartalyticsRace.where(status: "finished").find_each do |race|
      race_time = race.race_time

      next unless race_time
      if race.course.best_time.nil? || race_time < race.course.best_time
        race.course.update_attributes best_time: race_time
      end
    end
  end
end
