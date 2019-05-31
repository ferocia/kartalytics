# frozen_string_literal: true

class SlackParser
  class UnknownDateFormat < StandardError
  end

  COMMAND_ARG_TRIGGERS = %w[since scoped].freeze

  def initialize(params)
    @league_id = params[:token]
    @tokens = params[:text].downcase.split
    @trigger_word = @tokens.shift
    @command_trigger = @tokens.shift
  end

  def execute
    # Command triggers
    command = case @command_trigger
              when 'help'
                HelpCommand.new(@league_id, @trigger_word)
              when 'chart'
                LeaderboardChartCommand.new(
                  @league_id,
                  scope_by_date,
                  include_title:  false,
                  scope_to_names: scope_by_players
                )
              when 'leaderboard_trueskills'
                TrueskillLeaderboardCommand.new(@league_id, scope_by_date)
              when 'leaderboard_elo'
                LeaderboardCommand.new(@league_id, scope_by_date)
              when 'leaderboard'
                TrueskillLeaderboardCommand.new(@league_id, scope_by_date)
              when 'result'
                SubmitMatchCommand.new(@league_id, @tokens)
              when 'undo'
                UndoLastMatchCommand.new(@league_id)
              when 'courses'
                CoursesCommand.new(@league_id)
              when 'inspect'
                InspectPlayerCommand.new(@league_id, @tokens.first)
              else
                return error_response("Unknown command #{@command_trigger}")
    end
    present_command(command)

  # Handle inspect command errors
  rescue InspectPlayer::MissingPlayerNameError
    error_response('You gotta give me a player name, bro!')
  rescue InspectPlayer::MissingPlayerError => e
    error_response("#{e} ain't a player, bro!")
  # Handle match submission errors
  rescue Match::UnknownPlayerError => e
    error = <<~UNKNOWN_PLAYER_MESSAGE.strip
      Unknown player: '#{e}'

      Known players
      -------------
      #{Player.all.map(&:name).sort.join("\n")}
UNKNOWN_PLAYER_MESSAGE
    error_response(error)
  rescue Match::DuplicatePlayerError
    error_response('No duplicates please, bro D:')
  rescue Match::NotEnoughPlayersError
    error_response('You need to give me at least two players, bro D:')
  rescue UnknownDateFormat => e
    error_response(e.message)
  end

  def error_response(text)
    text_response(text)
  end

  def text_response(text)
    { text: "\n```\n#{text}\n```" }
  end

  def image_response(title:, image_url:)
    {
      attachments: [
        {
          title:     title,
          image_url: image_url
        }
      ]
    }
  end

  def present_command(command)
    result = command.execute
    command_type = result.is_a?(Hash) && result[:type] ? result[:type] : :text
    case command_type
    when :text
      text_response(result)
    when :image
      image_response(result.slice(:image_url, :title))
    end
  end

  def scope_by_players
    trigger_index = @tokens.index('scoped')
    return unless trigger_index
    trigger_index += 1 if @tokens[trigger_index + 1] == 'to'

    scoped_players = []
    1.upto(4) do |i|
      player_name = @tokens[trigger_index + i].to_s.downcase
      scoped_players << player_name unless COMMAND_ARG_TRIGGERS.include?(player_name)
    end
    scoped_players.uniq
  end

  def scope_by_date
    trigger_index = @tokens.index('since')
    if trigger_index
      time_increment = @tokens[trigger_index + 1].to_i
      time_mode = @tokens[trigger_index + 2].strip
      unless time_mode =~ /^(second|minute|hour|day|week|month|year)s?$/ && time_increment.positive?
        raise UnknownDateFormat, "Unknown date scoping format. Example: `#{@trigger_word} #{@command_trigger} since 5 months ago`"
      end
      time_increment.public_send(time_mode).ago
    else
      1.month.ago
    end
  end
end
