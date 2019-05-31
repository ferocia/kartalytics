# frozen_string_literal: true

class SubmitMatchCommand < Command
  def initialize(league_id, player_names)
    super(league_id)
    @player_names = player_names
  end

  def execute
    Match.create_for!(@league_id, @player_names)
    TrueskillLeaderboardCommand.new(@league_id, 1.month.ago).execute
  end

  private

  def players
    @players ||= @player_names.map do |name|
      Player.find_by(name: name) || raise(UnknownPlayerError, name)
    end
  end
end
