require 'rmagick'
require './screens/loading_screen'

class RMagick
  include Magick
end

class Analyser
  def self.analyse!(filename)
    new(filename).analyse!
  end

  attr_reader :filename
  attr_reader :image

  def initialize(filename)
    @filename = filename
    @image    = prepare_image(filename)
  end

  def analyse!
    current_screen = screens.find do |screen|
      screen.matches_image?(image)
    end

    if current_screen
      puts "Filename #{filename} is of type #{current_screen.class}"
      event = current_screen.extract_event(image)

      puts "Event #{event.inspect} extracted"

      return event
    end
  end

  def prepare_image(filename)
    # Prepare file/normalise dimensions/format? Anything else?
    image = Magick::Image.read(filename).first
    image.resize_to_fit!(300)
    image.write("tmp.jpg")
    image
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
      LoadingScreen
    ]
  end
end