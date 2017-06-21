class RaceScreen
  # Strat:
  #   Should have a black line separating vertical (caters for 2 - 4 players)
  #   Other pixels should not be black
  def self.matches_image?(screenshot)
    width = screenshot.original.columns
    height = screenshot.original.rows

    h, s, centre_brightness = screenshot.original.get_pixels(width / 2, 0, 1, 1).first.to_hsla
    h, s, top_left_brightness = screenshot.original.get_pixels(0, 0, 1, 1).first.to_hsla

    centre_brightness < 5 && top_left_brightness > 20
  end

  def self.extract_event(screenshot)
    {
      event_type: 'race_screen'
    }
  end
end
