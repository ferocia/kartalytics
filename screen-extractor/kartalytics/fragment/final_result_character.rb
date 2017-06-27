require_relative '../image_base'
require 'phashion'

module Kartalytics
  module Fragment
    class ResultCharacter < ImageBase
      WIDTH = 22
      HEIGHT = 22

      def initialize(image)
        super
        validate_image_dimensions(WIDTH, HEIGHT)
      end

      def to_sym
        possible_characters.each { |c| return c if send(:is?, c) }
        :unknown
      end

      private

      def possible_characters
        %i[black_yoshi white_yoshi light_blue_yoshi lakitu tanooki_mario baby_luigi inkling_girl rosalina mario
           dry_bowser baby_rosalina donkey_kong]
      end

      def is?(character)
        threshold = (character =~ /yoshi/) ? 4 : 10
        Phashion::Image.new("phashion/final_result_characters/#{character}.jpg").duplicate?(phashion_image, threshold: threshold)
      end

      def phashion_image
        @phashion_image ||= begin
          file_path = "_tmp_delete_me.jpg"
          image.write(file_path)
          Phashion::Image.new(file_path)
        end
      end
    end
  end
end
