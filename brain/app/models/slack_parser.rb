# frozen_string_literal: true

class SlackParser
  class UnknownDateFormat < StandardError
  end

  class UnknownSortFormat < StandardError
  end

  COMMAND_ARG_TRIGGERS = %w[since scoped].freeze

  def initialize(params)
    # temporary logging
    Rails.logger.info(params)

    @params = params
    @league_id = params[:token]
    # the gsub is to get rid of any non-breaking spaces that slack sometimes
    # puts into messages, specifically when trying to copy-paste
    @tokens = params[:text].downcase.gsub(/[[:space:]]/, ' ').split
    @trigger_word = @tokens.shift
    @command_trigger = @tokens.shift
  end

  def execute
    # Command triggers
    command = case @command_trigger
              when 'help'
                HelpCommand.new(@league_id, @trigger_word)
              when 'chart_trueskills'
                LeaderboardChartCommand.new(
                  @league_id,
                  scope_by_date,
                  algorithm: 'trueskills',
                  include_title:  false,
                  scope_to_names: scope_by_players
                )
              when 'chart', 'chart_elo'
                LeaderboardChartCommand.new(
                  @league_id,
                  scope_by_date,
                  algorithm: 'elo',
                  include_title:  false,
                  scope_to_names: scope_by_players
                )
              when 'mojo', 'mojo_chart'
                MojoChartCommand.new(
                  @league_id,
                  scope_by_date(nil),
                  player_names: scope_by_players,
                )
              when 'leaderboard_elo'
                LeaderboardCommand.new(@league_id, since: scope_by_date)
              when 'leaderboard', 'leaderboard_trueskills'
                TrueskillLeaderboardCommand.new(@league_id, since: scope_by_date, **(sort_by || {}))
              when 'result'
                SubmitMatchCommand.new(@league_id, @tokens)
              when 'undo'
                UndoLastMatchCommand.new(@league_id)
              when 'courses', 'records'
                CoursesCommand.new(@league_id, player_name: scope_by_players)
              when 'streaks'
                StreaksCommand.new(@league_id)
              when 'perfect_matches', 'perfect_games', 'perfect_scores'
                PerfectMatchesCommand.new(@league_id, player_name: scope_by_players)
              when 'inspect'
                InspectPlayerCommand.new(@league_id, @tokens.first)
              when 'add', 'new_player'
                CreatePlayerCommand.new(@tokens.first)
              when 'gen_courses', 'gen'
                GenCoursesCommand.new(@league_id)
              else
                if !@tokens.length.zero?
                  SubmitMatchCommand.new(@league_id, [@command_trigger] + @tokens)
                else
                  return error_response("Unknown command #{@command_trigger}")
                end
    end
    present_command(command)

  # Handle inspect command errors
  rescue InspectPlayer::MissingPlayerNameError
    error_response('You need to give me a player name 🏄‍♀️')
  rescue InspectPlayer::MissingPlayerError, MojoChartCommand::MissingPlayerError => e
    error_response("#{e} doesn't exist 😿")
  rescue MojoChartCommand::InvalidNumberOfPlayers => e
    error_response('You need to give me exactly two player names 🏄‍♀️')
  # Handle match submission errors
  rescue Match::UnknownPlayerError => e
    if @command_trigger == 'result'
      error = <<~UNKNOWN_PLAYER_MESSAGE.strip
        Unknown player: '#{e}'

        Known players
        -------------
        #{Player.all.map(&:name).sort.join("\n")}
UNKNOWN_PLAYER_MESSAGE
      error_response(error)
    else
      error_response("Unknown command #{@command_trigger}")
    end
  rescue Match::DuplicatePlayerError
    error_response('No duplicates please 🤦‍♀️')
  rescue Match::NotEnoughPlayersError
    error_response('You need to give me at least two players 👯‍♂️')
  rescue UnknownDateFormat, UnknownSortFormat => e
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
      image_response(**result.slice(:image_url, :title))
    when :raw
      { text: result[:text], blocks: result[:blocks] || [] }
    end
  end

  def scope_by_players
    trigger_index = @tokens.index('scoped')
    return unless trigger_index
    trigger_index += 1 if @tokens[trigger_index + 1] == 'to'

    scoped_players = []
    1.upto(4) do |i|
      player_name = @tokens[trigger_index + i].to_s.downcase
      break if COMMAND_ARG_TRIGGERS.include?(player_name)
      scoped_players << player_name unless player_name.empty?
    end
    scoped_players.uniq
  end

  def scope_by_date(default = 1.month.ago)
    trigger_index = @tokens.index('since')
    if trigger_index
      time_increment = @tokens[trigger_index + 1].to_i
      time_mode = @tokens[trigger_index + 2].strip
      unless time_mode =~ /^(second|minute|hour|day|week|month|year)s?$/ && time_increment.positive?
        raise UnknownDateFormat, "Unknown date scoping format. Example: `#{@trigger_word} #{@command_trigger} since 5 months ago`"
      end
      time_increment.public_send(time_mode).ago
    else
      default
    end
  end

  def sort_by
    trigger_index = @tokens.index('sort')
    return unless trigger_index
    trigger_index += 1 if @tokens[trigger_index + 1] == 'by'
    column = @tokens[trigger_index + 1]
    order = @tokens[trigger_index + 2] || 'asc'

    unless column =~ /^(rank|name|score|delta|games)$/
      raise UnknownSortFormat, "Unknown sort column. Allowed columns are `rank`, `name`, `score`, `delta`, and `games`"
    end

    unless order =~ /^(asc|desc)$/
      raise UnknownSortFormat, "Unknown sort order. Allowed orders are `asc` and `desc`"
    end

    { sort_column: column, order: order }
  end
end
