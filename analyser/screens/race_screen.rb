class RaceScreen
  # Strat:
  #   First quarter of pixels in centre line should be consistently black
  def self.matches_image?(screenshot)
    if screenshot.splitscreen?
      width  = screenshot.original.columns
      height = screenshot.original.rows

      centre_col_brightness = screenshot.original.get_pixels((width / 2) - 1, 0, 1, height / 8).map{|pixel|
        pixel.to_hsla[2]
      }.max

      centre_col_brightness <= 20
    end
  end

  def self.extract_event(screenshot)
    {
      event_type: 'race_screen'
    }
  end
end
