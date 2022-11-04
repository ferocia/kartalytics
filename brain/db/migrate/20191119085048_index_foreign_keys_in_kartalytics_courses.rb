class IndexForeignKeysInKartalyticsCourses < ActiveRecord::Migration[5.2]
  def change
    add_index :kartalytics_courses, :champion_id
  end
end
