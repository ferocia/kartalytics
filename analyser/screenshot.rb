require 'rmagick'

class RMagick
  include Magick
end

class Screenshot
  attr_reader :image
  attr_reader :filename

  WORKING_SIZE = 300

  def initialize(filename)
    @filename = filename
    # This takes about ~60ms
    @image = Magick::Image.read(filename).first.resize_to_fit!(300)
    # If necessary, this guy completes in half the time:
    # @image = Magick::Image.read(filename).first.resize!(300, 168, Magick::TriangleFilter)
  end

  def to_s
    @filename
  end

  def write_tmp
    @image.write('tmp.jpg')
  end

  def ten_px
    @ten_px = image.resize_to_fit(10)
  end
end