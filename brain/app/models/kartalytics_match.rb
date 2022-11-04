# frozen_string_literal: true

class KartalyticsMatch < ApplicationRecord
  has_many :races, class_name: 'KartalyticsRace', dependent: :destroy
  belongs_to :match

  belongs_to :player_one, class_name: 'Player'
  belongs_to :player_two, class_name: 'Player'
  belongs_to :player_three, class_name: 'Player'
  belongs_to :player_four, class_name: 'Player'

  has_many :entered_races, dependent: :destroy
  has_many :entered_matches, dependent: :destroy

  validates :status, presence: true

  scope :finished, -> { where(status: 'finished') }
  scope :with_players, -> { includes(:player_one, :player_two, :player_three, :player_four) }

  PLAYERS = %i[player_one player_two player_three player_four].freeze

  class MatchAssignmentError < StandardError
  end

  self.per_page = 10

  def self.current_match
    last if last&.status == 'in_progress'
  end

  def self.unassigned
    where('match_id IS NULL AND status <> ?', 'abandoned')
  end

  def self.recent_unassigned_for(player_count)
    unassigned
      .where(player_count: player_count)
      .where('created_at < ? AND created_at > ?', 5.minutes.ago, 6.hours.ago)
      .order('created_at DESC')
  end

  # count how many times these people have played in a row
  def count_matches_in_a_row
    count = 1

    return count if !players_assigned?

    id = self.id

    loop do
      prev_match = self.class.where('id < ?', id).order(id: :DESC).first
      if prev_match.player_names_in_alphabetical_order == self.player_names_in_alphabetical_order
        id = prev_match.id
        count += 1
      else
        break
      end
    end

    count
  end

  def players_in_order
    PLAYERS.sort_by { |player| public_send("#{player}_order").to_i }
  end

  # ikk order = by score then reverse leaderboard position at this exact moment in time
  # leaderboard_position is slow & expensive, so this method should be called sparingly
  def players_in_ikk_order
    PLAYERS.sort_by do |player|
      [
        -public_send("#{player}_score").to_i,
        -(public_send(player).try(:leaderboard_position, League.id_for('kart'), 1.month.ago) || Float::INFINITY)
      ]
    end
  end

  def player_names_in_order
    players_in_order.map { |player| public_send(player.to_s).try(:name) }.compact
  end

  def player_names_in_alphabetical_order
    PLAYERS.map { |player| public_send(player.to_s).try(:name) }.compact
  end

  def name
    if status == 'abandoned'
      'Abandoned'
    elsif players_assigned?
      player_names_in_order.map(&:humanize).join(', ')
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

  def present_players
    if players_assigned?
      players_in_order.select { |p| public_send(p).present? }
    else
      players_in_order
    end
  end

  def assigned?
    match.present?
  end

  def players_assigned?
    players = [player_one, player_two, player_three]
    players << player_four if player_count == 4
    players.all?(&:present?)
  end

  def started?
    races.any?
  end

  def abandon!
    update(status: 'abandoned')
  end

  def associate_players!(players)
    raise 'Cannot change players for an assigned match' if assigned?

    update(player_one: nil, player_two: nil, player_three: nil, player_four: nil)
    players.each do |key, player|
      public_send("#{key}=", player)
    end
    save
  end

  def associate_match!(match)
    update!(match: match)
    update_player_associations!
  rescue MatchAssignmentError => e
    update!(match: nil)
    Rails.logger.error e.message
  end

  def unassociate_match!
    update!(
      match:        nil,
      player_one:   nil,
      player_two:   nil,
      player_three: nil,
      player_four:  nil
    )

    clear_existing_associations!
  end

  def update_player_associations!
    return unless status == 'finished'

    clear_existing_associations!

    reassign_player_names!
    updated_entered_matches!
    updated_entered_races!
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

  def update_player_order!
    players_in_ikk_order.each_with_index do |player, index|
      public_send("#{player}_order=", index)
    end
    save
  end

  def update_player_scores!
    update!(
      player_one_score:   races.map(&:player_one_score).map(&:to_i).sum,
      player_two_score:   races.map(&:player_two_score).map(&:to_i).sum,
      player_three_score: races.map(&:player_three_score).map(&:to_i).sum,
      player_four_score:  races.map(&:player_four_score).map(&:to_i).sum
    )

    update_player_order!
  end

  # if all races are finished, calculate scores based on race results as this is
  # accurate. if there are unfinished races, we may have missed a race results
  # screen, so we need to use the less accurate score data from the event.
  def update_player_scores_from_event!(event)
    return update_player_scores! if races.all?(&:finished?)

    data = event.fetch(:data)

    # never reduce a players score; pick max of current score or event score
    update!(
      player_one_score: [player_one_score, data[:player_one].try(:[], :score)].map(&:to_i).max,
      player_two_score: [player_two_score, data[:player_two].try(:[], :score)].map(&:to_i).max,
      player_three_score: [player_three_score, data[:player_three].try(:[], :score)].map(&:to_i).max,
      player_four_score: [player_four_score, data[:player_four].try(:[], :score)].map(&:to_i).max,
    )

    update_player_order!
  end

  def reassign_player_names!
    positions = players_in_order.map do |player|
      [player, public_send("#{player}_position")]
    end

    positions = positions.reject do |_player, position|
      position.nil?
    end

    players = match.players_in_order.split(',')

    if positions.length != players.length
      raise MatchAssignmentError, "Could not assign player names due to a mismatch in player count #{positions.length} positions detected vs #{players.inspect} players"
    end

    match.players.each_with_index do |player, index|
      public_send("#{positions[index].first}=", player)
    end

    save
  end

  def update_interim_results!
    update_player_scores!
  end

  def estimated_player_count
    # avoid O(n). ie if :player_four is present, we know all players are present
    player = PLAYERS.reverse.find { |player| player_likely_present?(player) }
    PLAYERS.index(player).to_i + 1
  end

  def update_player_count!
    update!(player_count: estimated_player_count)
  end

  def finalize!(event)
    clean_up_races

    data = event.fetch(:data)
    update!(
      status:                'finished',

      player_one_position:   data[:player_one].try(:[], 'position'),
      player_two_position:   data[:player_two].try(:[], 'position'),
      player_three_position: data[:player_three].try(:[], 'position'),
      player_four_position:  data[:player_four].try(:[], 'position'),
    )

    update_player_scores_from_event!(event)

    if assigned?
      update_player_associations!
    elsif players_assigned? && races.length >= 4
      publish!
    end
  end

  def publish!
    ::Slack.notify(":kart: result #{player_names_in_order.join(' ')}")
  end

  private

  # determine whether the given player symbol is likely present based on the
  # percentage of race snapshots that contain data for the player (> 20%), as
  # the analyser sometimes detects false positives for players that don't exist
  def player_likely_present?(player)
    positions = races.joins(:race_snapshots).pluck("kartalytics_race_snapshots.#{player}_position")
    positions.compact.size.to_f / positions.size > 0.2
  end

  # sometimes the analyser detects phantom races during transitions and replays.
  # when the match is finalized, we can clean up by destroying unfinished races.
  def clean_up_races
    races.each do |race|
      race.destroy unless race.finished? || race.any_players_finished? || race.race_snapshots.size >= 20
    end
    reload
  end
end
