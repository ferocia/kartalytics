# frozen_string_literal: true

class HelpCommand < Command
  def initialize(league_id, trigger_word)
    super(league_id)
    @trigger_word = trigger_word
  end

  def execute
    <<~EOS.strip
      usage:
        #{@trigger_word} result 1st 2nd etc...         - submit a match
        #{@trigger_word} help                          - this help
        #{@trigger_word} leaderboard                   - show the leaderboard (trueskills for the last month)
        #{@trigger_word} leaderboard_elo               - show the leaderboard using Elo algorithm (last month)
        #{@trigger_word} leaderboard_trueskills        - show the leaderboard using Trueskills algorithm (last month)
        #{@trigger_word} chart                         - chart results (elo for the last month)
        #{@trigger_word} chart_elo                     - chart results using Elo algorithm (last month)
        #{@trigger_word} chart_trueskills              - chart results using Trueskills algorithm (last month)
        #{@trigger_word} courses                       - show course records
        #{@trigger_word} streaks                       - show streak leaderboard
        #{@trigger_word} perfect_matches               - show perfect matches leaderboard
        #{@trigger_word} undo                          - undo the last match
        #{@trigger_word} add {player_name}             - create a new player
        #{@trigger_word} inspect {player_name}         - show matchup breakdown
        Scope commands:
        #{@trigger_word} leaderboard since 1 week ago  - show any leaderboard scoped to any length of time (eg 7 months ago will also work)
        #{@trigger_word} chart since 1 week ago        - show any chart scoped to any length of time (eg 7 months ago will also work)
        #{@trigger_word} chart scoped to tom juzzy     - show any chart scoped to 1-4 players (space delimited)
        #{@trigger_word} mojo scoped to tom juzzy      - show mojo chart scoped to 2 players any length of time
        #{@trigger_word} perfect_matches scoped to tom - show perfect matches for just a player
        Sort commands:
        #{@trigger_word} leaderboard sort games desc   - show the leaderboard sorted by games descending
        #{@trigger_word} leaderboard sort by name      - show the leaderboard sorted by name ascending
EOS
  end
end
