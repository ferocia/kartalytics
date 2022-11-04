# frozen_string_literal: true

class StreaksCommand < Command
  def initialize(league_id)
    super(league_id)
  end

  def execute
    players = Player.all.map do |p|
      OpenStruct.new(
        name: p.name.downcase,
        current_streak: 0,
        highest_streak: 0,
      )
    end

    Match.all.order('created_at ASC').each do |match|
      winner = match.player_names.first.downcase

      players.map! do |player|
        if match.player_names.map(&:downcase).include?(player.name)
          if player.name == winner
            player.current_streak += 1
            player.highest_streak = [player.current_streak, player.highest_streak].max
          else
            player.current_streak = 0
          end
        end

        player
      end
    end

    players_in_order = players.select { |p| p.highest_streak > 3 }.sort_by { |p| [-p.highest_streak, p.name] }
    rows = players_in_order.map { |p| [p.name, p.highest_streak] }

    Terminal::Table.new(
      title: 'Top Streaks',
      headings: ['Player', 'Streak'],
      rows: rows
    ).to_s
  end
end
