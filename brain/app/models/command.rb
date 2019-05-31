# frozen_string_literal: true

class Command
  attr_reader :league_id

  def initialize(league_id)
    @league_id = league_id
  end
end
