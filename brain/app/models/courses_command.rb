# frozen_string_literal: true

class CoursesCommand < Command
  def initialize(league_id)
    super(league_id)
  end

  def execute
    rows = []

    player_races = EnteredRace.fastest_races_per_course.group_by do |race|
      race.player.name
    end

    player_races.each do |_player, races|
      races.each_with_index do |race, index|
        if index.zero?
          rows.push [
            "#{race.player.name} (#{races.count})",
            race.course.name,
            race.race_time
          ]
        else
          rows.push [
            '',
            race.course.name,
            race.race_time
          ]
        end
      end
    end

    Terminal::Table.new(
      title:    'Course Champions',
      headings: %w[Champion Course Time],
      rows:     rows
    ).to_s
  end
end
