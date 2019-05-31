class EventPresenter

  def initialize(default_race_count: nil)
    @default_race_count = default_race_count
  end

  def present
    return {} if current_match.nil?

    {
      status: current_match.status,
      title: title,
      leaderboard: leaderboard_attributes,
      race: race_attributes
    }
  end

  private

  def title
    "Race #{current_match.races.count}"
  end

  def leaderboard_attributes
    attributes = [:player_one, :player_two, :player_three, :player_four].map{|player|
      {
        player: player,
        score: current_match.public_send("#{player}_score"),
        color: KartalyticsRace.colour(player),
        label: current_match.public_send("#{player}_name")
      }
    }.sort{|a,b|
      b[:score] <=> a[:score]
    }

    attributes.each_with_index do |player_status, index|
      player_status[:position] = index + 1
    end

    attributes
  end

  def race_attributes
    return nil if current_race.nil?

    current_race.to_chart_json.merge(course_attributes)
  end

  def course_attributes
    course = current_race.course

    {
      course_name: course.name,
      course_image: course.image,
      course_best_time: course.best_time,
      course_record_set: course.best_time && course.best_time == (current_race.race_time || 0)
    }
  end

  def current_match
    @current_match ||= KartalyticsMatch.last
  end

  def current_race
    current_match.races.last
  end
end
