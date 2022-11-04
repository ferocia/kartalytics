# frozen_string_literal: true

class CoursesCommand < Command
  def initialize(league_id, player_name: nil)
    super(league_id)

    # if player_name is populated, it's gonna be an array
    @player_name = player_name&.first
  end

  def execute
    rows = []

    player_races = EnteredRace
      .fastest_races_per_course

    if player.present?
      player_races = player_races.select { |race| race.player == player }
    end

    player_races = player_races.group_by { |race| race.player.name }

    player_races.each do |_player, races|
      races.each_with_index do |race, index|
        row = if index.zero?
          ["#{race.player.name} (#{races.count})"]
        else
          [""]
        end

        row += [
          race.course.name,
          race.race_time,
        ]

        rows << row
      end
    end

    title = if player.present?
      "#{@player_name}'s Course Records"
    else
      'Course Champions'
    end

    Terminal::Table.new(
      title:    title,
      headings: ["Champion", "Course", "Time"],
      rows:     rows
    ).to_s
  end

  def player
    @player ||= begin
      return nil if @player_name.nil?

      Player.find_by(name: @player_name)
    end
  end
end
