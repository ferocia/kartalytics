# frozen_string_literal: true

class Leaderboard
  def initialize(league_id, since = 10.years.ago)
    @league_id = league_id
    @since = since
  end

  def latest
    last_match = nil
    Match.where(league_id: @league_id).where('created_at > ?', @since).find_each do |match|
      MatchProcessor.process(match, all_players)
      last_match = match
    end

    if last_match
      all_players.values.each do |player|
        player.score_change_last_match = 0 unless last_match.player_names.include?(player.name)
        player.rating_change_last_match = 0 unless last_match.player_names.include?(player.name)
      end
    end

    all_players.values.reject do |player|
      player.matches_played == 0
    end.sort
  end

  def all_players
    @all_players ||= Player.all.each_with_object({}) do |player, players|
      players[player.name] = player
      players
    end
  end
end
