# frozen_string_literal: true

class KartalyticsCourse < ApplicationRecord
  UNKNOWN_COURSE_NAME = "Unknown Course".freeze

  has_many :races, class_name: 'KartalyticsRace'
  has_many :entered_races, foreign_key: 'course_id'

  validates :name, presence: true

  def image
    file_name = "courses/#{name.parameterize.underscore}.jpg"
    ActionController::Base.helpers.asset_path(file_name)
  rescue Exception
    ActionController::Base.helpers.image_path("courses/missing_image.jpg")
  end

  def fastest_race
    return if unknown?
    @fastest_race ||= entered_races.ordered_by_race_time.first
  end

  def best_time
    return unless fastest_race
    fastest_race.race_time
  end

  def best_time_for(player)
    return if player.nil? || unknown?
    @best_time_for ||= {}
    @best_time_for[player] ||= entered_races.where(player: player).ordered_by_race_time.first&.race_time
  end

  def champion
    return unless fastest_race
    fastest_race.player
  end

  def record_set?(new_time)
    return false if new_time.nil? || new_time < 30 || unknown?
    best_time.nil? || new_time < best_time
  end

  def pb_set_for?(player, new_time)
    return false if player.nil? || new_time.nil? || unknown?
    player_best_time = best_time_for(player)
    player_best_time.nil? || new_time < player_best_time
  end

  def record_delta(new_time)
    return if best_time.nil? || new_time.nil? || unknown?
    new_time - best_time
  end

  def wr_delta(new_time)
    return if world_record_time <= 0 || new_time.nil? || unknown?
    new_time - world_record_time
  end

  def wr_delta_time
    return unless best_time
    best_time - world_record_time
  end

  def pb_delta_for(player, new_time)
    return if player.nil? || new_time.nil? || unknown?
    player_best_time = best_time_for(player)
    new_time - player_best_time if player_best_time
  end

  def top_records(scoped_players: nil, uniq: false, limit: nil)
    races = entered_races.ordered_by_race_time.includes(:player)
    races = races.where(player: scoped_players) if scoped_players.present?
    races = races.uniq { |race| race.player_id } if uniq
    races = races.take(limit) if limit.present?
    races.map do |race|
      {
        player_name: race.player.name,
        race_time: race.race_time
      }
    end
  end

  def top_players(scoped_players: nil, limit: 5)
    races = entered_races.includes(:player)
    races = races.where(player: scoped_players) if scoped_players.present?
    players = races.where("final_position IS NOT NULL").group_by(&:player).map do |player, races|
      games = races.length
      wins = races.select { |r| r.final_position == 1 }.length

      {
        player_name: player.name,
        games: games,
        wins: wins,
        ratio: (wins.to_f / games).round(2)
      }
    end

    players.sort_by { |p| [-[p[:games], limit].min, 1.0 - p[:ratio]] }.take(limit)
  end

  def unknown?
    name == UNKNOWN_COURSE_NAME
  end
end
