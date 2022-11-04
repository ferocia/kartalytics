# frozen_string_literal: true

module Entities::Kartalytics
  class Event < Grape::Entity
    expose :title
    expose :current_match, as: :match, with: Entities::Kartalytics::Match
    expose :race

    private

    def title
      "Race #{current_match.races.count}"
    end

    def race
      return if current_match.assigned? || current_race.nil?

      current_race.to_chart_json.merge(course_attributes)
    end

    def course_attributes
      course = current_race.course

      attributes = {
        course_name: course.name,
        course_image: course.image,
        course_champion: course.champion.try(:name),
        course_best_time: course.best_time,
      }

      # avoid expensive db hits after race has started
      if current_race.race_snapshots.empty?
        players = if current_match.players_assigned?
          current_match.present_players.map { |symbol| current_match.public_send(symbol.to_s) }
        end

        attributes.merge!(
          course_top_records: course.top_records(scoped_players: players, uniq: true, limit: 5),
          course_top_players: course.top_players(scoped_players: players),
        )
      end

      attributes
    end

    def previous_match
      @previous_match ||= ::KartalyticsMatch.second_to_last
    end

    def current_match
      @current_match ||= ::KartalyticsMatch.last
    end

    def current_race
      @current_race ||= current_match.races.last
    end
  end
end
