require 'rmagick'

module Kartalytics
  class Digit < ImageBase
    WIDTH = 21
    HEIGHT = 28

    def initialize(image)
      @image = high_contrast_image load_image(image)
      validate_image_dimensions(WIDTH, HEIGHT)
    end

    def to_i
      numbers = { zero?: 0, one?: 1, two?: 2, three?: 3, four?: 4, five?: 5, seven?: 7, nine?: 9 }
      numbers.each { |k, v| return v if send(k) }
      nil
    end

    def zero?
      top_bar? && top_right_bar? && bottom_right_bar? && bottom_bar? && bottom_left_bar? && top_left_bar? && !middle_horizontal?
    end

    def one?
      is? %i(middle_verticle)
    end

    def two?
      is? %i(top_bar top_right_bar middle_horizontal bottom_left_bar bottom_bar)
    end

    def three?
      is? %i(top_bar top_right_bar middle_horizontal bottom_right_bar bottom_bar)
    end

    def four?
      is? %i(top_left_bar middle_horizontal top_right_bar bottom_right_bar)
    end

    def five?
      is? %i(top_bar top_left_bar middle_horizontal bottom_right_bar bottom_bar)
    end

    def seven?
      is? %i(top_bar top_right_bar bottom_right_bar)
    end

    def nine?
      is? %i(top_bar top_left_bar top_right_bar middle_horizontal bottom_right_bar bottom_bar)
    end

    private

    def bars

    end

    def is?(expected)
      bars = %i(top_bar top_right_bar bottom_right_bar bottom_bar bottom_left_bar top_left_bar middle_horizontal
                middle_verticle)

      bars.all? do |b|
        result = send("#{b}?".to_sym)
        expected.include?(b) ? result : !result
      end
    end

    def dominate_colour(img)
      img.scale(1, 1).pixel_color(0, 0)
    end

    def grayish?(colour)
      colour < Magick::Pixel.from_color('gray')
    end

    def high_contrast_image(img)
      high_contrast = img.quantize(256, Magick::GRAYColorspace)
      high_contrast = high_contrast.black_threshold(38_000)
      high_contrast = high_contrast.white_threshold(0)
      high_contrast = high_contrast.negate
      high_contrast = high_contrast.negate if grayish? dominate_colour(high_contrast)
      high_contrast
    end

    def top_bar?
      bar = sub_image(6, 1, 9, 3)
      grayish? dominate_colour(bar)
    end

    def top_right_bar?
      bar = sub_image(15, 5, 5, 6)
      grayish? dominate_colour(bar)
    end

    def bottom_right_bar?
      bar = sub_image(15, 18, 5, 6)
      grayish? dominate_colour(bar)
    end

    def bottom_bar?
      bar = sub_image(6, 25, 9, 3)
      grayish? dominate_colour(bar)
    end

    def bottom_left_bar?
      bar = sub_image(1, 18, 5, 6)
      grayish? dominate_colour(bar)
    end

    def top_left_bar?
      bar = sub_image(1, 5, 5, 6)
      grayish? dominate_colour(bar)
    end

    def middle_horizontal?
      bar = sub_image(5, 14, 10, 2)
      grayish? dominate_colour(bar)
    end

    def middle_verticle?
      bar1 = sub_image(9, 5, 2, 7)
      bar2 = sub_image(9, 17, 2, 7)
      grayish?(dominate_colour(bar1)) && grayish?(dominate_colour(bar2))
    end
  end
end
