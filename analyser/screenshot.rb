require 'rmagick'

class RMagick
  include Magick
end

class Screenshot
  attr_reader :working
  attr_reader :original
  attr_reader :filename

  # A reasonable size to make subsequent adjustments
  WORKING_WIDTH = 300
  WORKING_HEIGHT = 169

  def initialize(filename)
    @filename = filename
    @original = Magick::Image.read(filename).first
  end

  def to_s
    @filename
  end

  def timestamp
    File.ctime(@filename).iso8601(3)
  end

  def destroy!
    @original.destroy!
    @working.destroy! if defined?(@working)
  end

  def working
    # This takes about ~60ms

    # If necessary, this guy completes in half the time:
    # @working = @original.resize(300, 168, Magick::TriangleFilter)

    @working ||= @original.dup.resize_to_fit!(WORKING_WIDTH)
  end

  def splitscreen?
    return @is_splitscreen if defined?(@is_splitscreen)
    width  = original.columns
    height = original.rows

    # Should have a black line separating vertical (caters for 2 - 4 players)
    # Other pixels should not be black

    h, s, centre_brightness      = original.get_pixels((width / 2) - 1, 0, 1, 1).first.to_hsla
    h, s, top_left_brightness    = original.get_pixels(0, 0, 1, 1).first.to_hsla
    h, s, bottom_left_brightness = original.get_pixels(height - 1, 0, 1, 1).first.to_hsla

    @is_splitscreen = centre_brightness <= 30 && ( top_left_brightness > 20 || bottom_left_brightness > 20)
    @is_splitscreen
  end
end
