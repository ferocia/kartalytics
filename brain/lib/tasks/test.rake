# frozen_string_literal: true

namespace :test do
  namespace :leaderboard do
    desc 'Print Elo leaderboard'
    task elo: :environment do
      league_id = League.id_for('kart')
      puts LeaderboardCommand.new(league_id, since: 1.month.ago).execute
    end

    desc 'Print trueskills leaderboard out'
    task trueskills: :environment do
      league_id = League.id_for('kart')
      puts TrueskillLeaderboardCommand.new(league_id, since: 6.months.ago).execute
    end
  end

  desc 'Generate google chart of matches'
  task chart: :environment do
    league_id = League.id_for('kart')
    puts 'Generated google chart:'
    puts
    result = LeaderboardChartCommand.new(league_id, 1.month.ago, scope_to_names: 'mike').execute
    puts " * #{result[:image_url]}"
    puts
  end
end
