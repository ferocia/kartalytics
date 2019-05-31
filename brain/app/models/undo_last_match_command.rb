# frozen_string_literal: true

class UndoLastMatchCommand < Command
  def initialize(league_id)
    super(league_id)
  end

  def execute
    Match.where(league_id: @league_id).last.destroy
    TrueskillLeaderboardCommand.new(@league_id).execute
  end
end
