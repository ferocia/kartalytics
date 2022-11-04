# frozen_string_literal: true

class PerfectMatchesCommand < Command
  def initialize(league_id, player_name: nil)
    super(league_id)

    # if player_name is populated, it's gonna be an array
    @player_name = player_name&.first
  end

  def execute
    if @player_name.present?
      solo
    else
      all
    end
  end

  def solo
    player = Player.find_by(name: @player_name)
    perfect_matches = player.perfect_matches.order(id: :desc)

    rows = perfect_matches.map do |match|
      kart_match = match.kartalytics_match
      item = kart_match.players_in_order.map do |player|
        player_name = kart_match.send("#{player}_name")
        player_score = kart_match.send("#{player}_score")

        "#{player_name} (#{player_score})"
      end.join(", ")

      [item]
    end

    Terminal::Table.new(
      title: "#{rows.length} Perfect #{"Match".pluralize(rows.length)} for #{@player_name}",
      rows: rows,
    ).to_s
  end

  def all
    players = Player.all.map do |p|
      perfect_matches = p.perfect_matches.order(id: :asc)

      OpenStruct.new(
        name: p.name.downcase,
        count: perfect_matches.count,
        last_match_id: perfect_matches.last&.id,
      )
    end

    players_in_order = players.select { |p| p.count > 0 }.sort_by { |p| [-p.count, p.last_match_id] }
    rows = players_in_order.map { |p| [p.name, p.count] }

    Terminal::Table.new(
      title: 'Perfect Matches',
      headings: ['Player', 'Matches'],
      rows: rows
    ).to_s
  end
end
