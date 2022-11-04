class IndexForeignKeysInKartalyticsState < ActiveRecord::Migration[5.2]
  def change
    add_index :kartalytics_state, :current_match_id
    add_index :kartalytics_state, :current_race_id
  end
end
