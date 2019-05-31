class RaceResultScreen < Screen
  # Strat:
  #   Should be splitscreen but not first quarter black
  def self.matches_image?(screenshot)
    if screenshot.splitscreen?
      width  = screenshot.original.columns
      height = screenshot.original.rows

      centre_col_brightness = screenshot.original.get_pixels((width / 2) - 1, 0, 1, height / 8).map{|pixel|
        pixel.to_hsla[2]
      }.max

      if centre_col_brightness > 50
        # Take orangy/greeny/blue pixels from leaderboard moves
        pixels_that_look_like_rank_moves = screenshot.working.get_pixels(75, 14, 1, 145).select do |pixel|
          mostly_red?(pixel) ||
          mostly_green?(pixel) ||
          mostly_blue?(pixel)
        end.count

        pixels_that_look_like_rank_moves < 10
      end
    end
  end

  def self.extract_event(screenshot)
    # Get a 1px strip of blank scoreboard so we can analyse the colors for player positions

    scoreboard = screenshot.working.get_pixels(209, 11, 1, 146)

    # There's two things we need to work out
    #  - Where is the player
    #  - what position did the player come
    player_positions = get_player_positions(scoreboard)

    data = add_points_information(player_positions)

    unless data.empty?
      {
        data: data,
        event_type: 'race_result_screen'
      }
    end
  end

  POINTS_AWARDED = [15, 12, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1]

  def self.add_points_information(player_positions)
    player_positions.keys.each do |player|
      player_positions[player] = player_positions[player].merge(
        points: POINTS_AWARDED[player_positions[player][:position] - 1]
      )
    end
    player_positions
  end

  def self.get_player_positions(scoreboard)
    results = { }

    # We've got about 144px of scoreboard (146 actually)
    # Which means on average about 12px per player row
    # Simply sum the offset where we get a pixel of player
    # colour and the position with the great qty of pixels
    # is their position
    scoreboard.each_with_index do |pixel, offset|
      # Debug:
      # puts "#{(offset / 12)+1} #{pixel.to_hsla.inspect}"
      player = player_pixel_color(pixel)


      if player
        results[player] ||= {}
        estimated_position = (offset / 12) + 1
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
