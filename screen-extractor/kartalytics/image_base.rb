require 'rmagick'

module Kartalytics
  class ImageBase
    attr_reader :image

    def initialize(image)
      @image = load_image(image)
    end

    def validate_image_dimensions(width, height)
      return if image.rows == height && image.columns == width
      raise ArgumentError, 'Image has incorrect dimensions'
    end

    def sub_image(x, y, w, h)
      cropped = image.crop(x, y, w, h)
      new_image = Magick::Image.new(cropped.columns, cropped.rows) { self.background_color = 'red' }
      new_image.composite(cropped, 0, 0, Magick::OverCompositeOp)
    end

    private

    def load_image(image)
      return image if image.is_a? Magick::Image
      Magick::Image.read(image)[0]
    end
  end
end
