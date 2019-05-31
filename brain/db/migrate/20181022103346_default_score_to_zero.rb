class DefaultScoreToZero < ActiveRecord::Migration[5.1]
  def change
    change_column :kartalytics_matches, :player_one_score, :integer, default: 0
    change_column :kartalytics_matches, :player_two_score, :integer, default: 0
    change_column :kartalytics_matches, :player_three_score, :integer, default: 0
    change_column :kartalytics_matches, :player_four_score, :integer, default: 0
  end
end
