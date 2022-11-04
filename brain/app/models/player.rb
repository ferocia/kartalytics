# frozen_string_literal: true

require 'saulabs/trueskill'

class Player < ApplicationRecord
  include Comparable
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  has_many :entered_races
  has_many :entered_matches
  has_many :kartalytics_matches, through: :entered_matches
  has_many :courses, -> { distinct }, through: :entered_races

  attr_accessor :matches_played, :streak, :position_last_match, :extinguisher
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
    @extinguisher = false

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

  def average_score
    scores = recent_scores
    scores.present? ? (scores.sum / scores.size.to_f).round : 0
  end

  # return hash with comparison with other players
  def compare(league_id)
    wins = {}
    losses = {}
    results = {}
    last_match = {}

    Match.where(league_id: league_id).find_each do |match|
      match_players   = match.player_names
      player_position = match_players.index(name)
      next unless player_position
      match_players.each_with_index do |other_player, other_player_position|
        if player_position < other_player_position
          wins[other_player] ||= 0
          wins[other_player] = wins[other_player] + 1
          results[other_player] ||= []
          results[other_player] << 1
          last_match[other_player] = match
        elsif player_position > other_player_position
          losses[other_player] ||= 0
          losses[other_player] = losses[other_player] + 1
          results[other_player] ||= []
          results[other_player] << -1
          last_match[other_player] = match
        end
      end
    end

    Player.order(:name).each_with_object(comparison = {}) do |player, other_players|
      next if player.name == name
      next unless wins[player.name] || losses[player.name]

      wins_against_player   = wins[player.name] || 0
      losses_against_player = losses[player.name] || 0
      results_against_player = results[player.name] || []
      mojo = wins_against_player - losses_against_player
      other_players[player.name] = {
        wins:   wins_against_player,
        losses: losses_against_player,
        results: results_against_player,
        mojo:   mojo,
        last_match_played_at: last_match[player.name]&.created_at
      }
    end
    Hash[comparison.sort_by { |_k, v| v[:mojo] }.reverse]
  end

  def perfect_matches
    entered_matches.where(final_score: 90)
  end

  def on_fire?
    streak > 3
  end

  def name_with_decorations
    decorations = ""
    decorations += "🔥" if on_fire?
    decorations += "🧯" if extinguisher

    return "#{name} #{decorations}" if decorations != ""
    name
  end

  def number_of_matches
    kartalytics_matches.size
  end

  def recent_matches(limit: 5)
    kartalytics_matches.with_players.order('created_at DESC').limit(limit)
  end

  def recent_scores(limit: nil)
    matches = entered_matches.order('id ASC')
    matches = matches.last(limit) if limit
    matches.pluck(:final_score)
  end

  def rival_results(league_id)
    compare(league_id)
      .sort_by do |_k, rival|
        recent_results = rival[:results].last(24) # calculate mojo for the last 24 matches
        absolute_mojo = recent_results.sum.abs # smaller absolute mojo == closer rivalry
        days_stale = difference_in_days(Time.now, rival[:last_match_played_at])
        decay = days_stale * 0.5 # decay by 0.5 per day not played
        [-recent_results.length, absolute_mojo + decay]
      end
      .map { |rival| { name: rival[0], results: rival[1][:results].last(6) } }
      .first(3)
  end

  def course_records
    entered_races = EnteredRace.fastest_races_per_course
    player_records = entered_races.select { |race| race.player_id == self.id }
  end

  def image_url
    begin
      ActionController::Base.helpers.image_path("players/#{name.downcase}.png")
    rescue Exception
      Player.default_image
    end
  end

  def leaderboard_position(league_id, since)
    TrueskillLeaderboard.new(league_id, since).position_for(self)
  end

  def self.default_image
    ActionController::Base.helpers.image_path("players/default.png")
  end

  # finds a player by their name or <@SLACK_ID> mention
  def self.find_by_mention(mention)
    _, slack_id, _, slack_name = mention.match(/<@(\w+)(\|(\w+))?>/).to_a

    return Player.find_by('UPPER(slack_id) = ?', slack_id.upcase) if slack_id
    Player.find_by(name: mention)
  end

  private

  def difference_in_days(date1, date2)
    (date2.to_date - date1.to_date).to_i.abs
  end
end
