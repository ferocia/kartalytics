# frozen_string_literal: true

class TrueskillLeaderboardCommand < Command
  include ActionView::Helpers::DateHelper

  def initialize(league_id, since = nil)
    @since = if since
      since
    else
      first_match = Match.first
      first_match ? first_match.created_at : 5.years.ago
    end
    super(league_id)
  end

  SCALE = 1 / 10.0
  def execute
    players = TrueskillLeaderboard.new(league_id, @since).latest

    rows = []
    players.each_with_index do |player, rank|
      score_change      = score_change_text((player.score_change_last_match.to_i * SCALE).round)
      player_name       = Player.name_with_decorations(name: player.name, streak: player.streak)
      streak            = streak_text(player.streak)
      last_match_rank   = last_match_rank_for_player(player.name)
      last_score_change = last_match_rank ? score_change : nil

      rows << [
        rank + 1, player_name, (player.calculated_score.to_i * SCALE).round,
        last_score_change, last_match_rank,
        streak, player.matches_played
      ]
    end

    Terminal::Table.new(
      title:    "Leaderboard since #{distance_of_time_in_words(Time.zone.now, @since)} ago",
      headings: %w[
        Rank Name Score
        Change Place
        Streak Played
      ],
      rows:     rows
    ).to_s
  end

  private

  def last_match_result
    @last_match_result ||= Match.where(league_id: league_id).last.player_names
  end

  def last_match_rank_for_player(name)
    last_match_result.index(name) + 1 if last_match_result.include?(name)
  end

  def streak_text(streak)
    streak > 0 ? streak.to_s : ''
  end

  def score_change_text(score_change)
    if score_change > 0
      "+#{score_change}"
    elsif score_change == 0
      ''
    else
      score_change.to_s
    end
  end
end
