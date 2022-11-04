# frozen_string_literal: true

class TrueskillLeaderboardCommand < Command
  HEADINGS_MAP = {
    rank: '#',
    name: 'Name',
    score: 'Score',
    delta: '∆',
    games: '🎮'
  }.with_indifferent_access.freeze

  include ActionView::Helpers::DateHelper

  def initialize(league_id, since: nil, sort_column: nil, order: nil, scoped_players: [])
    @sort_column = sort_column
    @order = order
    @scoped_players = scoped_players
    @since = if since
      since
    else
      first_match = Match.first
      first_match ? first_match.created_at : 5.years.ago
    end
    super(league_id)
  end

  SCALE = 1 / 10.0
  LEAGUE_SIZE = 4

  def execute
    players = TrueskillLeaderboard.new(league_id, @since).latest

    headings = HEADINGS_MAP.map do |k, c|
      { value: c, alignment: :center }
    end

    player_rows = players.each_with_index.map do |player, rank|
      score_change      = score_change_text((player.score_change_last_match.to_i * SCALE).round)
      player_name       = player.name_with_decorations
      streak            = streak_text(player.streak)
      last_match_rank   = last_match_rank_for_player(player.name)
      last_score_change = last_match_rank ? score_change : nil

      display_name = if streak.present?
                       "#{player_name} (#{streak})"
                     else
                       player_name
                     end

      [
        { value: rank + 1, alignment: :right },
        { value: display_name },
        { value: (player.calculated_score.to_i * SCALE).round, alignment: :right },
        { value: last_score_change, alignment: :right },
        { value: player.matches_played, alignment: :right },
      ]
    end

    rows = if @sort_column
      sort_rows(player_rows)
    elsif players.length > LEAGUE_SIZE
      leaugify_rows(player_rows)
    else
      player_rows.clone
    end

    # we probably don't need this anymore?
    # title:    "Leaderboard since #{distance_of_time_in_words(Time.zone.now, @since)} ago",
    table = Terminal::Table.new(
      headings: headings,
      rows: rows,
      style: {
        padding_left: 0,
        padding_right: 0,
        border_top: false,
        border_bottom: false,
        border_y: "|",
        border_x: " ",
        border_i: " ",
      }).to_s.split("\n").reject(&:empty?).map { |l| l.slice(1..-2).rstrip }.join("\n")

    table
  end

  private

  def leaugify_rows(player_rows)
    rows = []
    slices = player_rows.each_slice(LEAGUE_SIZE).to_a
    slices.each_with_index do |slice, i|
      # pack the integer as a unicode character
      league = [(i + 'A'.ord)].pack('U')
      rows << [{ colspan: HEADINGS_MAP.to_a.length, value: "-------- #{league} League --------", alignment: :center }]
      slice.each { |p| rows << p }
    end

    player_indices = rows.each_index.select do |index|
      rows[index][1]&.fetch(:value) =~ /^(#{@scoped_players.join('|')})(\s|$)/
    end.sort

    return rows if player_indices.length < 2

    # slice leaderboard to one league above and below the spread of players
    start_index = [(player_indices.first / 5.0).floor * 5 - 5, 0].max
    end_index = (player_indices.last / 5.0).ceil * 5 + 5
    rows.slice(start_index, end_index - start_index)
  end

  def sort_rows(player_rows)
    sort_index = HEADINGS_MAP.to_a.index { |key,| key == @sort_column }
    rows = player_rows.sort_by do |p|
      if @sort_column == 'name'
        p[sort_index][:value].to_s
      else
        (p[sort_index][:value] || -Float::INFINITY).to_f
      end
    end
    @order == 'desc' ? rows.reverse : rows
  end

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
