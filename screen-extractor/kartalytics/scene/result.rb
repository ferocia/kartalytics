require_relative '../image_base'
require_relative '../fragment/score_board_character'

module Kartalytics
  module Scene
    class Result < ImageBase
      def initialize(image)
        super
        validate_image_dimensions(1280, 720)
      end

      def characters
        @characters ||= begin
          character_positions.map do |x, y|
            score_image = sub_image(x, y, Fragment::ScoreBoardCharacter::WIDTH, Fragment::ScoreBoardCharacter::HEIGHT)
            Fragment::ScoreBoardCharacter.new(score_image).to_sym
          end
        end
      end

      private

      def character_y_positions
        0.upto(11).map { |i| 62 + (52 * i) }
      end

      def character_x_positions
        Array.new(character_y_positions.size, 430)
      end

      def character_positions
        character_x_positions.zip(character_y_positions)
      end
    end
  end
end
