# frozen_string_literal: true

class MatchProcessor
  def self.process(match, players_map)
    players = match.players_in_order.split(',').map do |player|
      players_map[player]
    end.compact

    rating_changes = {}
    players.each_with_index do |player, player_pos|
      rating_change = 0
      players.each_with_index do |other_player, other_player_pos|
        if player_pos < other_player_pos
          rating_change += player.defeated(other_player)
        elsif player_pos > other_player_pos
          rating_change -= other_player.defeated(player)
        end
      end
      rating_changes[player.name] = rating_change
      player.matches_played = player.matches_played + 1
      player.streak = player_pos == 0 ? player.streak + 1 : 0
    end

    players.each do |player|
      old_player_rating = player.rating.to_i
      player.rating = player.rating + rating_changes[player.name]
      player.rating_change_last_match = player.rating.to_i - old_player_rating.to_i

      old_player_score = player.score
      player.score = [0, player.score + rating_changes[player.name]].max.to_i
      player.score_change_last_match = player.score - old_player_score
    end
  end
end
