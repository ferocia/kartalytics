# frozen_string_literal: true

class AddKartalyticsTables < ActiveRecord::Migration[5.1]
  def change
    create_table :kartalytics_courses do |t|
      t.string :name, null: false
    end

    create_table :kartalytics_races do |t|
      t.string :status, default: 'in_progress', null: false
      t.references :kartalytics_course, null: false
      t.references :kartalytics_match, null: false
      t.datetime :started_at, null: false
      t.datetime :finished_at

      t.integer :player_one_position
      t.integer :player_two_position
      t.integer :player_three_position
      t.integer :player_four_position

      t.datetime :player_one_finished_at
      t.datetime :player_two_finished_at
      t.datetime :player_three_finished_at
      t.datetime :player_four_finished_at

      t.integer :player_one_score
      t.integer :player_two_score
      t.integer :player_three_score
      t.integer :player_four_score
    end

    create_table :kartalytics_race_snapshots do |t|
      t.references :kartalytics_race, null: false
      t.datetime :timestamp, null: false
      t.integer :player_one_position
      t.integer :player_two_position
      t.integer :player_three_position
      t.integer :player_four_position
    end

    create_table :kartalytics_state do |t|
      t.integer :current_match_id
      t.integer :current_race_id
      t.json :last_event
    end

    create_table :kartalytics_matches do |t|
      t.references :match
      t.string :status, default: 'in_progress', null: false
      t.timestamps

      t.integer :player_one_score
      t.integer :player_two_score
      t.integer :player_three_score
      t.integer :player_four_score

      t.integer :player_one_position
      t.integer :player_two_position
      t.integer :player_three_position
      t.integer :player_four_position
    end

    add_foreign_key :kartalytics_state, :kartalytics_matches, column: :current_match_id
    add_foreign_key :kartalytics_state, :kartalytics_races, column: :current_race_id

    add_foreign_key :kartalytics_races, :kartalytics_courses
    add_foreign_key :kartalytics_races, :kartalytics_matches
    add_foreign_key :kartalytics_race_snapshots, :kartalytics_races
  end
end
