class AddChampionToKartalyticsCourses < ActiveRecord::Migration[5.1]
  def change
    add_column :kartalytics_courses, :champion_id, :bigint
    add_foreign_key :kartalytics_courses, :players, column: :champion_id
  end
end
