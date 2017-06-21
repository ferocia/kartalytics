require 'rmagick'

class RMagick
  include Magick
end

class Screenshot
  attr_reader :working
  attr_reader :original
  attr_reader :filename

  # A reasonable size to make subsequent adjustments
  WORKING_SIZE = 300

  def initialize(filename)
    @filename = filename
    @original = Magick::Image.read(filename).first
    # This takes about ~60ms
    @working = @original.resize_to_fit(300)
    # If necessary, this guy completes in half the time:
    # @working = @original.resize(300, 168, Magick::TriangleFilter)
  end

  def to_s
    @filename
  end

  def write_tmp
    @image.write('tmp.jpg')
  end

  def ten_px
    @ten_px = working.resize_to_fit(10)
  end
end