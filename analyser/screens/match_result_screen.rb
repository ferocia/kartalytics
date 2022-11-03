class MatchResultScreen < Screen
  # Strat:
  #   Compare with reference
  REFERENCE_150 = Phashion::Image.new("reference_images/match_result/150.jpg")
  REFERENCE_200 = Phashion::Image.new("reference_images/match_result/200.jpg")

  # where we may expect dark pixels in a 9-segment display
  SEGMENTS = [
    { x: 6, y: 1 },
    { x: 2, y: 7 },
    { x: 9, y: 7 },
    { x: 16, y: 7 },
    { x: 6, y: 14 },
    { x: 2, y: 19 },
    { x: 9, y: 19 },
    { x: 16, y: 19 },
    { x: 6, y: 25 },
  ]

  DIGITS = [
    { digit: 0, segments: [1, 1, 0, 1, 0, 1, 0, 1, 1] },
    { digit: 1, segments: [0, 0, 1, 0, 0, 0, 1, 0, 0] },
    { digit: 2, segments: [1, 0, 0, 1, 1, 1, 0, 0, 1] },
    { digit: 3, segments: [1, 0, 0, 1, 1, 0, 0, 1, 1] },
    { digit: 4, segments: [0, 1, 0, 1, 1, 0, 0, 1, 0] },
    { digit: 5, segments: [1, 1, 0, 0, 1, 0, 0, 1, 1] },
    { digit: 6, segments: [1, 1, 0, 0, 1, 1, 0, 1, 1] },
    { digit: 7, segments: [1, 0, 0, 1, 0, 0, 0, 1, 0] },
    { digit: 8, segments: [1, 1, 0, 1, 1, 1, 0, 1, 1] },
    { digit: 9, segments: [1, 1, 0, 1, 1, 0, 0, 1, 1] },
  ]

  def self.matches_image?(screenshot)
    race_speed(screenshot) != nil
  end

  def self.extract_event(screenshot)
    player_positions = get_player_positions(screenshot)

    unless player_positions.empty?
      {
        data: player_positions.merge(speed: race_speed(screenshot)),
        event_type: 'match_result_screen'
      }
    end
  end

  def self.get_player_positions(screenshot)
    scoreboard = screenshot.working.get_pixels(103, 30, 1, 120)

    results = { }

    # We've got about 120px of scoreboard (146 actually)
    # Which means on average about 10px per player row
    # Simply sum the offset where we get a pixel of player
    # colour and the position with the great qty of pixels
    # is their position
    scoreboard.each_with_index do |pixel, offset|
      player = player_pixel_color(pixel)

      if player
        results[player] ||= {}
        estimated_position = (offset / 10) + 1
        results[player][estimated_position] ||= 0
        results[player][estimated_position] += 1
      end
    end

    results.each do |player, possible_positions|
      position = possible_positions.select{ |position, likelihood| likelihood > 5 }.keys.first
      if position
        score = score_for(position, screenshot)
        results[player] = { position: position, score: score }
      else
        results.delete(player)
      end
    end
    results
  end

  private

  def self.score_for(position, screenshot)
    offset_x, offset_y = 520, 94
    col_width, row_height = 23, 42

    # change below to 0..2 for > 6 races. this risks a phantom hundreds digit
    # which could result in shockingly inaccurate scores (eg 999)
    digits = (1..2).map do |col_index|
      x = offset_x + col_index * col_width
      y = offset_y + position * row_height
      segments = SEGMENTS.map do |s|
        pixel = screenshot.original.get_pixels(x + s[:x], y + s[:y], 1, 1).first
        pixel.to_hsla[2] < 70 ? 1 : 0 # brightness
      end
      DIGITS.find { |d| d[:segments] == segments }&.fetch(:digit)
    end

    digits.compact.join.to_i
  end

  def self.race_speed(screenshot)
    crop = screenshot.original.dup.crop!(37, 28, 99, 26)
    img = crop.black_threshold(50000, 50000, 50000)

    crop.destroy!

    phash = convert_to_phash(img)

    if phash.distance_from(REFERENCE_150) < 10
      '150cc'
    elsif phash.distance_from(REFERENCE_200) < 10
      '200cc'
    end
  end

  def self.player_pixel_color(pixel)
    hue, sat, lum, alpha = pixel.to_hsla

    # Good should be around ~[56.00000000000002, 240.4285714285714, 167.5, 1.0]
    # Yellow
    if hue > 50 && hue < 65 && lum > 120 && sat > 200
      return :player_one
    end

    # Blue
    if hue > 170 && hue < 190 && lum > 130 && sat > 180
      return :player_two
    end

    # Red
    if (hue < 10 || hue > 340) && sat > 150 && lum > 150
      return :player_three
    end

    # Green
    if (hue > 85 && hue < 110) && sat > 170 && lum > 140
      return :player_four
    end
  end
end
