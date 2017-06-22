require 'rmagick'
require_relative 'image_base'
require_relative 'score_block'

module Kartalytics
  class FinalResult < ImageBase
    def initialize(image)
      super
      validate_image_dimensions(1280, 720)
    end

    def scores
      @scores ||= begin
        score_positions.map do |x, y|
          score_image = sub_image(x, y, ScoreBlock::WIDTH, ScoreBlock::HEIGHT)
          ScoreBlock.new(score_image).to_i
        end
      end
    end

    private

    def score_y_positions
      0.upto(11).map { |i| 135 + (42 * i) }
    end

    def score_x_positions
      Array.new(score_y_positions.size, 542)
    end

    def score_positions
      score_x_positions.zip(score_y_positions)
    end
  end
end
