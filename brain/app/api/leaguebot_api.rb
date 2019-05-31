# frozen_string_literal: true

# API routes
class LeaguebotAPI < Grape::API
  default_format :json
  format :json
  content_type :json, 'application/json'

  logger Rails.logger
  mount Resources::Players      => 'players'
  # trueskill spike
  mount Resources::Leaderboard  => 'leaderboard'
  mount Resources::Matches      => 'matches'
  mount Resources::Slack        => 'slack'
  mount Resources::Result       => 'result'
  mount Resources::Player       => 'player'
  mount Resources::Kartalytics  => 'kartalytics'
end
