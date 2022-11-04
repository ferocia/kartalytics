# frozen_string_literal: true

class CreatePlayerCommand < Command
  def initialize(player_name)
    @player_name = player_name
  end

  def execute
    begin
      Player.create!(name: @player_name)
      "#{@player_name} is ready to roll"
    rescue ActiveRecord::RecordInvalid => invalid
      invalid.record.errors.full_messages.join(', ')
    end
  end
end
