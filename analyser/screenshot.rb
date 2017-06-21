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
    @image = Magick::Image.read(filename).first.resize_to_fit!(300)
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