# frozen_string_literal: true

module Entities::Kartalytics
  class EventSelectPlayers < Grape::Entity
    expose :players, with: Entities::Kartalytics::Player
    expose :show_double_down?, as: :show_double_down
    expose :previous_matches_in_a_row

    private

    def players
      ::Player.all.order(:name)
    end

    def previous_matches_in_a_row
      previous_match.count_matches_in_a_row
    end

    def show_double_down?
      return false if current_match.nil? || previous_match.nil?
      return false if current_match.started?

      difference_in_seconds = current_match.created_at - previous_match.updated_at
      difference_in_seconds < 300
    end

    def previous_match
      @previous_match ||= ::KartalyticsMatch.second_to_last
    end

    def current_match
      @current_match ||= ::KartalyticsMatch.last
    end
  end
end
