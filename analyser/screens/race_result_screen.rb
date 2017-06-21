class RaceResultScreen
  # Strat:
  #   Should be splitscreen but not first quarter black
  def self.matches_image?(screenshot)
    if screenshot.splitscreen?
      width  = screenshot.original.columns
      height = screenshot.original.rows

      centre_col_brightness = screenshot.original.get_pixels((width / 2) - 1, 0, 1, height / 8).map{|pixel|
        pixel.to_hsla[2]
      }.max

      if centre_col_brightness > 20
        # Take orangy/greeny/blue pixels from leaderboard moves
        pixels_that_look_like_rank_moves = screenshot.working.dup.get_pixels(75, 14, 1, 145).select do |pixel|
          mostly_red?(pixel) ||
          mostly_green?(pixel) ||
          mostly_blue?(pixel)
        end.count

        pixels_that_look_like_rank_moves > 10
      end
    end
  end

  def self.extract_event(screenshot)


    {
      event_type: 'race_result_screen'
    }
  end

  private

  def self.mostly_red?(pixel)
    pixel.red > 40000 && pixel.green < 20000 && pixel.blue < 20000
  end

  def self.mostly_blue?(pixel)
    pixel.blue > 40000 && pixel.green < 20000 && pixel.red < 20000
  end

  def self.mostly_green?(pixel)
    pixel.green > 40000 && pixel.red < 20000 && pixel.blue < 20000
  end
end
