# frozen_string_literal: true

class KartalyticsMatch < ApplicationRecord
  has_many :races, class_name: 'KartalyticsRace'
  belongs_to :match

  belongs_to :player_one, class_name: 'Player'
  belongs_to :player_two, class_name: 'Player'
  belongs_to :player_three, class_name: 'Player'
  belongs_to :player_four, class_name: 'Player'

  has_many :entered_races
  has_many :entered_matches

  PLAYERS = %i[player_one player_two player_three player_four].freeze

  class MatchAssignmentError < StandardError
  end

  def self.current_match
    find_by(status: 'in_progress')
  end

  def self.unassigned
    where('match_id IS NULL AND status <> ?', 'abandoned')
  end

  def name
    if status == 'abandoned'
      'Abandoned'
    elsif player_one.present?
      players_in_order = PLAYERS.sort { |a, b| public_send("#{a}_position").to_i <=> public_send("#{b}_position").to_i }

      players_in_order.map { |player| public_send(player.to_s).try(:name) }.compact.map(&:humanize).join(', ')
    else
      'Unassigned match'
    end
  end

  def player_one_name
    (player_one.try(:name) || 'Player One').humanize
  end

  def player_two_name
    (player_two.try(:name) || 'Player Two').humanize
  end

  def player_three_name
    (player_three.try(:name) || 'Player Three').humanize
  end

  def player_four_name
    (player_four.try(:name) || 'Player Four').humanize
  end

  def assigned?
    match.present?
  end

  def abandon!
    update_attributes(status: 'abandoned')
  end

  def associate_match!(match)
    update_attributes!(match: match)
    update_player_associations!
  rescue MatchAssignmentError => e
    update_attributes!(match: nil)
    Rails.logger.error e.message
  end

  def update_player_associations!
    return unless assigned?
    return unless status == 'pending_player_assignment'

    clear_existing_associations!

    assign_player_names!
    updated_entered_matches!
    updated_entered_races!
    save
  end

  def clear_existing_associations!
    entered_matches.destroy_all
    entered_races.destroy_all
  end

  def updated_entered_matches!
    PLAYERS.each do |player_symbol|
      player = public_send(player_symbol.to_s)
      next unless player
      entered_matches.create!(
        player:         player,
        final_position: public_send("#{player_symbol}_position"),
        final_score:    public_send("#{player_symbol}_score")
      )
    end
  end

  def updated_entered_races!
    PLAYERS.each do |player_symbol|
      player = public_send(player_symbol.to_s)
      next unless player
      races.each do |race|
        race_time = race.public_send("#{player_symbol}_finished_at")

        race_time -= race.started_at if race_time.present?

        entered_races.create!(
          player:         player,
          race:           race,
          course:         race.course,
          race_time:      race_time,
          final_position: race.public_send("#{player_symbol}_position")
        )
      end
    end
  end

  def assign_player_names!
    # Pretty crazy - from the entered results and the positions we deduced from the result screen,
    # calculate what position everyone finished in
    positions = PLAYERS.map do |player|
      [player, public_send("#{player}_position")]
    end

    positions = positions.reject do |_player, position|
      position.nil?
    end.sort_by(&:last)

    players = match.players_in_order.split(',')

    if positions.length != players.length
      raise MatchAssignmentError, "Could not assign player names due to a mismatch in player count #{positions.length} positions detected vs #{players.inspect} players"
    end

    match.players.each_with_index do |player, index|
      public_send("#{positions[index].first}=", player)
    end
  end

  def update_interim_results!
    update_attributes!(
      player_one_score:   races.map(&:player_one_score).map(&:to_i).sum,
      player_two_score:   races.map(&:player_two_score).map(&:to_i).sum,
      player_three_score: races.map(&:player_three_score).map(&:to_i).sum,
      player_four_score:  races.map(&:player_four_score).map(&:to_i).sum
    )
  end

  def finalize!(event)
    data = event.fetch(:data)
    update_attributes!(
      status:                'pending_player_assignment',

      player_one_position:   data[:player_one].try(:[], 'position'),
      player_two_position:   data[:player_two].try(:[], 'position'),
      player_three_position: data[:player_three].try(:[], 'position'),
      player_four_position:  data[:player_four].try(:[], 'position'),

      player_one_score:      races.map(&:player_one_score).map(&:to_i).sum,
      player_two_score:      races.map(&:player_two_score).map(&:to_i).sum,
      player_three_score:    races.map(&:player_three_score).map(&:to_i).sum,
      player_four_score:     races.map(&:player_four_score).map(&:to_i).sum
    )

    update_player_associations!
  end
end
