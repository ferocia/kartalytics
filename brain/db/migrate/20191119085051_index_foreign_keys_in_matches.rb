class IndexForeignKeysInMatches < ActiveRecord::Migration[5.2]
  def change
    add_index :matches, :league_id
  end
end
