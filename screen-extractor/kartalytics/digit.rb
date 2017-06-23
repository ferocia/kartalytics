require 'rmagick'
require 'phashion'

module Kartalytics
  class Digit < ImageBase
    WIDTH = 21
    HEIGHT = 28

    def initialize(image)
      # @image = high_contrast_image load_image(image)
      super
      validate_image_dimensions(WIDTH, HEIGHT)
    end

    def to_i
      numbers = { zero?: 0, one?: 1, two?: 2, three?: 3, four?: 4, five?: 5, seven?: 7, nine?: 9 }
      numbers.each { |k, v| return v if send(k) }
      nil
    end

    def zero?
      Phashion::Image.new('digits/0.jpg').duplicate?(phashion_image)
    end

    def one?
      Phashion::Image.new('digits/1.jpg').duplicate?(phashion_image)
    end

    def two?
      Phashion::Image.new('digits/2.jpg').duplicate?(phashion_image)
    end

    def three?
      Phashion::Image.new('digits/3.jpg').duplicate?(phashion_image, threshold: 10)
    end

    def four?
      Phashion::Image.new('digits/4.jpg').duplicate?(phashion_image)
    end

    def five?
      Phashion::Image.new('digits/5.jpg').duplicate?(phashion_image, threshold: 10)
    end

    def seven?
      Phashion::Image.new('digits/7.jpg').duplicate?(phashion_image, threshold: 10)
    end

    def nine?
      Phashion::Image.new('digits/9.jpg').duplicate?(phashion_image)
    end

    private

    def phashion_image
      @phashion_image ||= begin
        file_path = 'debug_digit.jpg'
        image.write(file_path)
        Phashion::Image.new(file_path)
      end
    end
  end
end
