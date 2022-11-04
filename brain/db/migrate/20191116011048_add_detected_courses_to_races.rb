class AddDetectedCoursesToRaces < ActiveRecord::Migration[5.2]
  def change
    add_column :kartalytics_races, :detected_courses, :json, default: {}, null: false
  end
end
