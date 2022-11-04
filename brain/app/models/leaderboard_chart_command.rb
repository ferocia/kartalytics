# frozen_string_literal: true

require 'googlecharts'

class LeaderboardChartCommand < Command
  include ActionView::Helpers::DateHelper

  def initialize(league_id, since = nil, options = {})
    @options = {
      algorithm: 'trueskills',
      include_title:  true,
      scope_to_names: nil
    }.merge(options)
    @since = if since
      since
    else
      first_match = Match.first
      first_match ? first_match.created_at : 5.years.ago
    end
    super(league_id)
  end

  def execute
    result_data = {}

    all_players = Player.all.each_with_object({}) do |player, players|
      players[player.name] = player
      result_data[player.name] ||= []
      players
    end

    matches = Match
              .where(league_id: league_id)
              .where('created_at > ?', @since)

    matches.find_each do |match|
      match_players = if @options[:algorithm] == 'trueskills'
        TrueskillMatchProcessor.process(match, all_players)
      else
        MatchProcessor.process(match, all_players) # elo
      end

      played_names = match_players.map(&:name)
      missing_players = all_players.reject do |_player_name, player|
        played_names.include?(player.name)
      end

      (match_players + missing_players.values).each do |player|
        result_data[player.name] << player.score
      end
    end

    # Remove players with no results
    result_data.each do |player_name, player_result_data|
      result_data.delete(player_name) if player_result_data.uniq == [0]
    end

    # # Remove less than 0 results
    # result_data.each do |player_name, player_result_data|
    #   result_data.delete(player_name) if player_result_data[:data].last <= 0
    # end

    if @options[:scope_to_names]
      # Scope to specific players
      result_data.each do |player_name, _player_result_data|
        result_data.delete(player_name) unless @options[:scope_to_names].include?(player_name.downcase)
      end
    end

    title = "Leaderboard: #{matches.count} matches from #{distance_of_time_in_words(Time.zone.now, @since)} ago"
    image_url = generate_chart(title, result_data)

    { title:     title,
      type:      :image,
      image_url: image_url }
  end

  def generate_chart(title, result_data = {})
    names = result_data.keys
    data = []
    names.each do |name|
      data << result_data[name]
    end

    Chart::Theme.add_theme_file(Rails.root.join('config', 'chart_themes.yml'))
    Gchart.sparkline(
      theme:  :slack,
      size:   '750x400',
      title:  @options[:include_title] ? title : nil,
      legend: names,
      data:   data,
      encoding: :extended,
    )
  end
end
