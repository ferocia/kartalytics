# frozen_string_literal: true

class AddPlayers < ActiveRecord::Migration[5.1]
  def change
    create_table :players do |t|
      t.string :slack_id, unique: true
      t.string :name, null: false, unique: true
      t.timestamps
    end
  end
end
