require 'rmagick'

module Kartalytics
  class FinalResult
    attr_reader :image

    def initialize(image_path)
      @image = Magick::Image.read(image_path)[0]
    end
  end
end
