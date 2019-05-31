# frozen_string_literal: true

class TrueskillLeaderboard
  def initialize(league_id, since = 5.years.ago)
    @league_id = league_id
    @since = since
  end

  def latest
    Match.where(league_id: @league_id).where('created_at >= ?', @since).find_each do |match|
      TrueskillMatchProcessor.process(match, all_players)
    end
    all_players.each_with_index do |(_name, player), _position|
      # Only display change and last position result for last game
      unless last_match_result.include?(player.name)
        player.score_change_last_match  = nil
        player.position_last_match      = nil
      end
    end
    all_players.values.reject do |player|
      player.matches_played == 0
    end.sort
  end

  def all_players
    @all_players ||= Player.all.each_with_object({}) do |player, players|
      # reset attributes to floats
      # TODO: delete this when parent object is initialised as floats
      player.score = 0.0
      player.rating = 0.0
      player.score_change_last_match = nil
      player.position_last_match = nil

      players[player.name] = player
      players
    end
  end

  private

  def last_match_result
    @last_match_result ||= begin
      last_match = Match.where(league_id: @league_id).last
      last_match ? last_match.player_names : []
    end
  end
end
