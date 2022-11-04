# frozen_string_literal: true

class InspectPlayerCommand < Command
  def initialize(league_id, player_name)
    @player_name = player_name
    super(league_id)
  end

  def execute
    other_players = InspectPlayer.new(@league_id, @player_name).execute
    player = Player.find_by_mention(@player_name)

    rows = []
    other_players.each do |other_player_name, comparison|
      rows.push [
        other_player_name,
        comparison[:wins],
        comparison[:losses],
        comparison[:mojo]
      ]
    end

    rows.sort! { |a, b| a[3] <=> b[3] }
    Terminal::Table.new(
      title:    "#{player.name} vs...",
      headings: %w[Opponent Wins Losses Mojo],
      rows:     rows
    ).to_s
  end
end
