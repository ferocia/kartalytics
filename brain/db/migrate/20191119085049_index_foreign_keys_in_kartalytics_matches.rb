class IndexForeignKeysInKartalyticsMatches < ActiveRecord::Migration[5.2]
  def change
    add_index :kartalytics_matches, :player_four_id
    add_index :kartalytics_matches, :player_one_id
    add_index :kartalytics_matches, :player_three_id
    add_index :kartalytics_matches, :player_two_id
  end
end
