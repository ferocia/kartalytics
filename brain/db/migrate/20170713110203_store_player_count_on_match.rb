# frozen_string_literal: true

class StorePlayerCountOnMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :kartalytics_matches, :player_count, :integer
    change_column :entered_races, :final_position, :integer, null: true
  end
end
