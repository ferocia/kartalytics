class AddItemsToKartalyticsRaceSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :kartalytics_race_snapshots, :player_one_item, :string
    add_column :kartalytics_race_snapshots, :player_two_item, :string
    add_column :kartalytics_race_snapshots, :player_three_item, :string
    add_column :kartalytics_race_snapshots, :player_four_item, :string
  end
end
