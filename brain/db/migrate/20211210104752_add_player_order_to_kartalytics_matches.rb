class AddPlayerOrderToKartalyticsMatches < ActiveRecord::Migration[6.1]
  def change
    add_column :kartalytics_matches, :player_one_order, :integer, default: 0
    add_column :kartalytics_matches, :player_two_order, :integer, default: 0
    add_column :kartalytics_matches, :player_three_order, :integer, default: 0
    add_column :kartalytics_matches, :player_four_order, :integer, default: 0

    KartalyticsMatch.find_each do |match|
      players = KartalyticsMatch::PLAYERS.sort_by { |player| match.public_send("#{player}_position") || Float::INFINITY }
      players.each_with_index do |player, index|
        match.public_send("#{player}_order=", index)
      end
      match.save
    end
  end
end
