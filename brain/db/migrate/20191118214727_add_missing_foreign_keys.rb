class AddMissingForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :kartalytics_matches, :matches
  end
end
