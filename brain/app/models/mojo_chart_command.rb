# frozen_string_literal: true

require 'googlecharts'

class MojoChartCommand < Command
  include ActionView::Helpers::DateHelper

  class InvalidNumberOfPlayers < StandardError
  end

  class MissingPlayerError < StandardError
  end

  def initialize(league_id, since, player_names:)
    @since = since || Date.new
    @player_names = player_names

    super(league_id)
  end

  def execute
    raise(InvalidNumberOfPlayers) unless @player_names&.length == 2

    @player_names.each do |name|
      raise(MissingPlayerError, name) unless Player.find_by(name: name)
    end

    data = [0]

    matches =
      Match
        .where(league_id: league_id)
        .where('created_at > ?', @since)
        .order('created_at ASC')
        .select do |match|
          @player_names.all? { |name| match.player_names.include?(name) }
        end

    matches.each do |match|
      data << if match.player_names.index(@player_names[0]) < match.player_names.index(@player_names[1])
        data.last + 1
      else
        data.last - 1
      end
    end

    title = "Mojo: #{matches.count} matches from #{distance_of_time_in_words(Time.zone.now, matches.first&.created_at || @since)} ago"
    image_url = generate_chart(data)

    {
      title: title,
      type: :image,
      image_url: image_url,
    }
  end

  def generate_chart(data)
    Chart::Theme.add_theme_file(Rails.root.join('config', 'chart_themes.yml'))
    image_url = Gchart.line(
      theme: :slack,
      size: '750x400',
      data: [data, [0, 0]],
      encoding: :extended,
      axis_with_labels: ['x', 'y', 'r'],
      axis_labels: [
        [0], # x - provide first value. rest will be auto
        [data.min], # y - provide first value. rest will be auto
        [@player_names[1], @player_names[0]], # r - player at the bottom is second player entered
      ],
      axis_range: [[0, 0, 0], [0, 0, 0]],
      line_colors: [data.last > data.first ? '339933' : 'ff0000', 'C0C0C0'],
      thickness: '1|1,10,5'
    )
    replace_chxr(image_url, data)
  end

  # bug in gchart chxr: https://github.com/mattetti/googlecharts/blob/master/lib/gchart.rb#L514
  # if `step` is greater than `max`, `max` is set to the largest value in the `axis_range` array
  # and `step` removed. so `[-10, 5, 10]` becomes `-10,10` when it should be `-10,5,10`.
  def replace_chxr(image_url, data)
    chxr = "0,0,#{data.length},#{data.length / 20}|1,#{data.min},#{data.max},#{(data.min - data.max) / 15}"
    image_url.gsub('chxr=0,0,0,0|1,0,0,0', "chxr=#{chxr}")
  end
end
