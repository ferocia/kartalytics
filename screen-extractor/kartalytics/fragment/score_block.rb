require_relative '../image_base'
require_relative 'digit'

module Kartalytics
  module Fragment
    class ScoreBlock < ImageBase
      WIDTH = 44
      HEIGHT = 28

      def initialize(image)
        super
        validate_image_dimensions(WIDTH, HEIGHT)
      end

      def to_i
        digits = digit_positions.map do |x, y|
          digit_image = sub_image(x, y, Digit::WIDTH, Digit::HEIGHT)
          Digit.new(digit_image).to_i
        end
        digits.join.to_i
      end

      private

      def digit_x_positions
        [0, 23]
      end

      def digit_y_positions
        Array.new(digit_x_positions.size, 0)
      end

      def digit_positions
        digit_x_positions.zip(digit_y_positions)
      end
    end
  end
end
