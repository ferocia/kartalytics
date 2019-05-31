# frozen_string_literal: true

require 'saulabs/trueskill'

class Player < ApplicationRecord
  include Comparable
  validates :name, uniqueness: { case_sensitive: false }

  has_many :entered_races
  has_many :entered_matches

  attr_accessor :matches_played, :streak, :position_last_match
  attr_accessor :score,  :score_change_last_match
  attr_accessor :rating, :rating_change_last_match

  # trueskill spike
  # TODO: Deprecate rating + rating_change_last_match
  include ::Saulabs::TrueSkill
  attr_accessor :skill_rating

  POINT_PAD_MULTIPLIER = 1000

  after_initialize :set_defaults

  def set_defaults
    @matches_played, @streak, @position_last_match = 0, 0
    @score = 0
    @score_change_last_match = 0
    @rating = 0
    @rating_change_last_match = 0

    # Rating.new(25.0, 25.0 / 3.0, 1.0, 25.0 / 300.0)
    # TODO: add optional 'activity' to third arg
    #     : If played in last 3 months => 1.0
    #     : Every additional month after that reduce by 0.1 until 0
    @skill_rating = Rating.new(25.0, 25.0 / 3.0)
  end

  # Rating accurate to 99% (see http://en.wikipedia.org/wiki/TrueSkill)
  def calculated_score
    ((skill_rating.mean - (3 * skill_rating.deviation)) * POINT_PAD_MULTIPLIER)
  end

  # returns the number of points this player should gain for defeating other_player
  def defeated(other_player)
    Elo.new(rating, other_player.rating).rating_change_for_winner
  end

  def <=>(other)
    if score == other.score
      other.rating <=> rating
    else
      other.score <=> score
    end
  end

  # return hash with comparison with other players
  def compare(league_id)
    wins = {}
    losses = {}
    Match.where(league_id: league_id).find_each do |match|
      match_players   = match.player_names
      player_position = match_players.index(name)
      next unless player_position
      match_players.each_with_index do |other_player, other_player_position|
        if player_position < other_player_position
          wins[other_player] ||= 0
          wins[other_player] = wins[other_player] + 1
        elsif player_position > other_player_position
          losses[other_player] ||= 0
          losses[other_player] = losses[other_player] + 1
        end
      end
    end

    Player.order(:name).each_with_object(comparison = {}) do |player, other_players|
      next if player.name == name
      next unless wins[player.name] || losses[player.name]

      wins_against_player   = wins[player.name] || 0
      losses_against_player = losses[player.name] || 0
      mojo = wins_against_player - losses_against_player
      other_players[player.name] = {
        wins:   wins_against_player,
        losses: losses_against_player,
        mojo:   mojo
      }
    end
    Hash[comparison.sort_by { |_k, v| v[:mojo] }.reverse]
  end

  def self.name_with_decorations(name:, streak:)
    streak > 3 ? "#{name} 🔥" : name
  end
end
