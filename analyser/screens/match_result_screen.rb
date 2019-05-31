class MatchResultScreen < Screen
  # Strat:
  #   Compare with reference
  REFERENCE_150 = Phashion::Image.new("reference_images/match_result/150.jpg")
  REFERENCE_200 = Phashion::Image.new("reference_images/match_result/200.jpg")

  def self.matches_image?(screenshot)
    race_speed(screenshot) != nil
  end

  def self.extract_event(screenshot)
    scoreboard = screenshot.working.get_pixels(103, 30, 1, 120)

    player_positions = get_player_positions(scoreboard)

    unless player_positions.empty?
      {
        data: player_positions.merge(speed: race_speed(screenshot)),
        event_type: 'match_result_screen'
      }
    end
  end

  def self.get_player_positions(scoreboard)
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
        results[player] = {position: position}
      else
        results.delete(player)
      end
    end
    results
  end

  private

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
    if hue > 170 && hue < 190 && lum > 130 && sat > 190
      return :player_two
    end

    # Red
    if (hue < 10 || hue > 340) && sat > 170 && lum > 150
      return :player_three
    end

    # Green
    if (hue > 85 && hue < 110) && sat > 170 && lum > 140
      return :player_four
    end
  end
end
