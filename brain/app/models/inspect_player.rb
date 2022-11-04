# frozen_string_literal: true

class InspectPlayer
  class MissingPlayerNameError < StandardError
  end
  class MissingPlayerError < StandardError
  end

  def initialize(league_id, player_name)
    @league_id = league_id
    @player_name = player_name
  end

  def execute
    raise(MissingPlayerNameError) unless @player_name

    player = Player.find_by_mention(@player_name)
    raise(MissingPlayerError, @player_name) unless player

    player.compare(@league_id)
  end
end
