class MatchResultScreen
  # Strat:
  #   Top left and bottom right should be red
  def self.matches_image?(screenshot)
    top_left_pixel = screenshot.working.dup.crop(0,0,7,7).resize(1,1).get_pixels(0,0,1,1).first
    bottom_right_pixel = screenshot.working.dup.crop(292,161,7,7).resize(1,1).get_pixels(0,0,1,1).first

    (top_left_pixel.red > 40000 && bottom_right_pixel.red > 40000) &&
      (top_left_pixel.green < 300 && bottom_right_pixel.green < 300) &&
      (top_left_pixel.blue < 300 && bottom_right_pixel.blue < 300)
  end

  def self.extract_event(screenshot)
    {
      event_type: 'match_result_screen'
    }
  end
end
