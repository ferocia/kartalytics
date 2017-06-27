require_relative 'result'

module Kartalytics
  module Scene
    class FinalResult < Result
      def initialize(image)
        super
        validate_image_dimensions(1280, 720)
      end

      # private

      # def score_y_positions
      #   0.upto(11).map { |i| 135 + (42 * i) }
      # end
      #
      # def score_x_positions
      #   Array.new(score_y_positions.size, 542)
      # end
      #
      # def score_positions
      #   score_x_positions.zip(score_y_positions)
      # end
    end
  end
end
