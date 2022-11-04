class AddWorldRecordToKartalyticsCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :kartalytics_courses, :world_record_time, :float, null: false, default: 0
  end
end
