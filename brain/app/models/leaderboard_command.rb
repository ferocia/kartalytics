# frozen_string_literal: true

class LeaderboardCommand < Command
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

  def execute
    players = Leaderboard.new(league_id, @since).latest
    rows = []
    players.each_with_index do |player, rank|
      score_change = if player.score_change_last_match > 0
        "+#{player.score_change_last_match}"
      elsif player.score_change_last_match == 0
        ''
      else
        player.score_change_last_match.to_s
      end

      rating_change = if player.rating_change_last_match > 0
        "+#{player.rating_change_last_match}"
      elsif player.rating_change_last_match == 0
        ''
      else
        player.rating_change_last_match.to_s
      end

      streak = player.streak > 0 ? player.streak.to_s : ''
      rows << [rank + 1, Player.name_with_decorations(name: player.name, streak: player.streak), player.score, score_change, player.matches_played, streak, player.rating.to_i, rating_change]
    end

    Terminal::Table.new(
      title:    "Leaderboard since #{distance_of_time_in_words(Time.zone.now, @since)} ago",
      headings: ['Rank', 'Name', 'Score', 'Change', 'Played', 'Streak', 'Raw ELO', 'Change'],
      rows:     rows
    ).to_s
  end
end
