# frozen_string_literal: true

class AddKartalyticsPlayerTables < ActiveRecord::Migration[5.1]
  def change
    create_table :entered_races do |t|
      t.references :player, null: false
      t.references :race, null: false
      t.references :course, null: false
      t.references :kartalytics_match, null: false
      t.float :race_time # Can be null
      t.integer :final_position, null: false
    end

    add_foreign_key :entered_races, :players
    add_foreign_key :entered_races, :kartalytics_races, column: :race_id
    add_foreign_key :entered_races, :kartalytics_courses, column: :course_id
    add_foreign_key :entered_races, :kartalytics_matches

    create_table :entered_matches do |t|
      t.references :player, null: false
      t.references :kartalytics_match, null: false
      t.integer :final_position
      t.integer :final_score
    end

    add_foreign_key :entered_matches, :players
    add_foreign_key :entered_matches, :kartalytics_matches

    add_column :kartalytics_matches, :player_one_id, :integer
    add_column :kartalytics_matches, :player_two_id, :integer
    add_column :kartalytics_matches, :player_three_id, :integer
    add_column :kartalytics_matches, :player_four_id, :integer

    add_foreign_key :kartalytics_matches, :players, column: :player_one_id
    add_foreign_key :kartalytics_matches, :players, column: :player_two_id
    add_foreign_key :kartalytics_matches, :players, column: :player_three_id
    add_foreign_key :kartalytics_matches, :players, column: :player_four_id
  end
end
