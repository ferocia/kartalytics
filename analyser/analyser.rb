require 'phashion'
require 'time'
require './screenshot'
require './screens/fast_ignore'
require './screens/race_screen'
require './screens/race_result_screen'
require './screens/match_result_screen'
require './screens/loading_screen'
require './screens/intro_screen'

class Analyser
  def self.analyse!(filename)
    new(filename).analyse!
  end

  attr_reader :image

  def initialize(filename)
    @image = Screenshot.new(filename)
  end

  def analyse!
    current_screen = screens.find do |screen|
      start = Time.now
      is_screen = screen.matches_image?(image)
      # puts "Analysing for screen #{screen.name.to_s} took: #{(Time.now - start).round(4)}"

      is_screen
    end

    # sort_image(image, current_screen)

    if current_screen
      start = Time.now
      event = current_screen.extract_event(image)

      if event
        event.merge!(timestamp: image.timestamp)
      end

      puts "Processed #{image} (#{(Time.now - start).round(4)}) #{current_screen.name} => #{event.inspect} "
      return event
    end
  end

  def sort_image(image, current_screen)
    directory = "./classified/" + (current_screen || "Unsorted").to_s
    Dir.mkdir(directory) unless Dir.exists?(directory)
    image.working.write("#{directory}/#{File.basename(image.filename)}")
  end

  # Detect if main menu
  # Detect if loading screen
  # Detect if start race screen
  #   (attempt to gather race name)
  # Detect if mid race screen
  #   (attempt to gather positions/items/coins for each player)
  # Detect if race results screen
  #   (attempt to gather positions/points for each player)
  # Detect if results screen
  #   (attempt to gather positions/points for each player)
  def screens
    [
      FastIgnore,
      RaceScreen,
      RaceResultScreen,
      LoadingScreen,
      MatchResultScreen,
      IntroScreen
    ]
  end
end