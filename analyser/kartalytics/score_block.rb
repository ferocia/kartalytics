require 'rmagick'

module Kartalytics
  class ScoreBlock < ImageBase
    WIDTH = 44
    HEIGHT = 28

    def initialize(image)
      super
      validate_image_dimensions(WIDTH, HEIGHT)
    end

    def to_i
      nil
    end
  end
end
