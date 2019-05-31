# frozen_string_literal: true

class AddMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.text :players_in_order, null: false
      t.string :league_id, null: false
      t.timestamps
    end
  end
end
