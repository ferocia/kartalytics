require 'rmagick'
require_relative 'image_base'

module Kartalytics
  class FinalResult < ImageBase
    def initialize(image)
      super
      validate_image_dimensions(1280, 720)
    end

    def scores
      @scores ||= begin
        score_blocks = score_positions.each_with_index(1).map do |(x, y), i|
          score_image = sub_image(image, x, y, ScoreBlock::WIDTH, ScoreBlock::HEIGHT)
          score_image.write("debug_#{i}.jpg")
          ScoreBlock.new(score_image)
        end

        score_blocks.map(&:to_i)
      end
    end

    private

    def score_y_positions
      0.upto(11).map { |i| 135 + (42 * i) }.freeze
    end

    def score_x_positions
      Array.new(score_y_positions.size, 542)
    end

    def score_positions
      @positions ||= SCORE_X_POSITIONS.zip(SCORE_Y_POSITIONS)
    end
  end
end
