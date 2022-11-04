class RemoveBestTimeAndChampionFromKartalyticsCourse < ActiveRecord::Migration[5.2]
  def change
    remove_index :kartalytics_courses, [:champion_id]

    remove_column :kartalytics_courses, :champion_id
    remove_column :kartalytics_courses, :best_time
  end
end
