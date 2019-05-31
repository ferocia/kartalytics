# frozen_string_literal: true

class Match < ApplicationRecord
  class DuplicatePlayerError < StandardError
  end
  class UnknownPlayerError < StandardError
  end
  class NotEnoughPlayersError < StandardError
  end

  def player_names
    @player_names ||= players_in_order.split(',')
  end

  def players
    player_names.map do |name|
      Player.find_by(name: name)
    end
  end

  def self.create_for!(league_id, player_names_in_order)
    raise(NotEnoughPlayersError) if player_names_in_order.length < 2
    raise(DuplicatePlayerError) if player_names_in_order.uniq.count != player_names_in_order.count

    player_names_in_order.each do |player_name|
      raise(UnknownPlayerError, player_name) unless Player.exists?(name: player_name)
    end
    match = Match.create!(league_id: league_id, players_in_order: player_names_in_order.join(','))
    KartalyticsState.associate_match(match)
    match
  end
end
