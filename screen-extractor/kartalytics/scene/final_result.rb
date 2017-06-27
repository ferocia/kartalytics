require_relative '../image_base'
require_relative '../fragment/final_result_character'

module Kartalytics
  module Scene
    class FinalResult < ImageBase
      def initialize(image)
        super
        validate_image_dimensions(1280, 720)
      end

      def characters
        @characters ||= begin
          character_positions.map do |x, y|
            score_image = sub_image(x, y, Fragment::FinalResultCharacter::WIDTH, Fragment::FinalResultCharacter::HEIGHT)
            Fragment::FinalResultCharacter.new(score_image).to_sym
          end
        end
      end

      private

      def character_y_positions
        0.upto(11).map { |i| 140 + (52 * i) }
      end

      def character_x_positions
        Array.new(character_y_positions.size, 120)
      end

      def character_positions
        character_x_positions.zip(character_y_positions)
      end
    end
  end
end
