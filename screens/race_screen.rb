class RaceScreen < Screen
  # Strat:
  #   First quarter of pixels in centre line should be consistently black
  def self.matches_image?(screenshot)
    if screenshot.splitscreen?
      width  = screenshot.original.columns
      height = screenshot.original.rows

      centre_col_top_brightness = screenshot.original.get_pixels((width / 2) - 1, 0, 1, height / 8).map{|pixel|
        pixel.to_hsla[2]
      }.max

      centre_col_bot_brightness = screenshot.original.get_pixels((width / 2) - 1, (7.0 / 8) * height, 1, (height / 8) - 1).map{|pixel|
        pixel.to_hsla[2]
      }.max

      centre_col_top_brightness <= 50 && centre_col_bot_brightness <= 50
    end
  end

  def self.extract_event(screenshot)
    positions = extract_postions(screenshot.original)

    # No point sending event if no data
    data = add_is_finished_status(screenshot.original, positions)
    data = player_items(screenshot.original, data)
    unless positions.empty?
      {
        event_type: 'race_screen',
        data: data
      }
    end
  end

  POSITION_CROP_XY = {
    player_one:   { x: 57, y: 239 },
    player_two:   { x: 1167, y: 239 },
    player_three: { x: 57, y: 599 },
    player_four:  { x: 1167, y: 599 }
  }


  FINISH_CROP_XY = {
    player_one:   { x: 159, y: 127 },
    player_two:   { x: 799, y: 127 },
    player_three: { x: 159, y: 487 },
    player_four:  { x: 799, y: 487 }
  }

  FINISH_REFERENCE = Phashion::Image.new("reference_images/race/finished.jpg")

  REFERENCE_IMAGES = [
    {pos: 1,  images: ["pos1.png", "pos1-alt.png"]},
    {pos: 2,  images: ["pos2.png"]},
    {pos: 3,  images: ["pos3.png"]},
    {pos: 4,  images: ["pos4.png", "pos4-alt.png"]},
    {pos: 5,  images: ["pos5.png"]},
    {pos: 6,  images: ["pos6.png", "pos6-alt.png"]},
    {pos: 7,  images: ["pos7.png","pos7-alt.png"]},
    {pos: 8,  images: ["pos8.png"]},
    {pos: 9,  images: ["pos9.png", "pos9-alt.png"]},
    {pos: 10, images: ["pos10.png", "pos10-alt.png"]},
    {pos: 11, images: ["pos11.png", "pos11-alt.png"]},
    {pos: 12, images: ["pos12.png", 'pos12-alt.jpg']},
  ].each do |ref|
    ref[:images] = ref[:images].map{|file| Phashion::Image.new("reference_images/race/#{file}") }
  end


  def self.add_is_finished_status(image, positions)
    FINISH_CROP_XY.keys.each do |player, position|
      img = image.dup.crop!(FINISH_CROP_XY[player][:x], FINISH_CROP_XY[player][:y], 38, 38)

      phash = convert_to_phash(img)

      if phash.distance_from(FINISH_REFERENCE) < 10
        positions[player] ||= {}
        positions[player][:status] = 'finish'
      end
    end
    positions
  end

  def self.extract_postions(image)
    result = {}
    POSITION_CROP_XY.each do |player, crop_xy|
      crop = image.dup.crop!(crop_xy[:x], crop_xy[:y], 36, 54)
      img = crop.quantize(256, Magick::GRAYColorspace, Magick::NoDitherMethod)
      crop.destroy!

      phashion_image = convert_to_phash(img)

      pos = REFERENCE_IMAGES.min_by do |reference|
        min_distance(phashion_image, reference)
      end

      # For debugging:
      # img.write("tmp-#{pos[:pos]}-distance-#{min_distance(phashion_image, pos)}-#{player}-#{rand(256)}.png")

      if min_distance(phashion_image, pos) < 16
        result[player] = {position: pos[:pos] }
      end
    end
    result
  end

  def self.min_distance(image, reference)
    reference[:images].map do |ref_image|
      image.distance_from(ref_image)
    end.min
  end

  # Item detection

  LOWER_Y_OFFSET = 360

  SMALL_ITEM = [34, 34]
  LARGE_ITEM = [61, 61]

  LEFT_SMALL_X = 49
  UPPER_SMALL_Y = 32

  LEFT_LARGE_X = 89
  UPPER_LARGE_Y = 52

  LOWER_SMALL_Y = UPPER_SMALL_Y + LOWER_Y_OFFSET
  LOWER_LARGE_Y = UPPER_LARGE_Y + LOWER_Y_OFFSET

  RIGHT_SMALL_X = 1197
  RIGHT_LARGE_X = 1130


  P1_SMALL = [LEFT_SMALL_X, UPPER_SMALL_Y, *SMALL_ITEM]
  P1_LARGE = [LEFT_LARGE_X, UPPER_LARGE_Y, *LARGE_ITEM]

  P2_SMALL = [RIGHT_SMALL_X, UPPER_SMALL_Y, *SMALL_ITEM]
  P2_LARGE = [RIGHT_LARGE_X, UPPER_LARGE_Y, *LARGE_ITEM]

  P3_SMALL = [LEFT_SMALL_X, LOWER_SMALL_Y, *SMALL_ITEM]
  P3_LARGE = [LEFT_LARGE_X, LOWER_LARGE_Y, *LARGE_ITEM]

  P4_SMALL = [RIGHT_SMALL_X, LOWER_SMALL_Y, *SMALL_ITEM]
  P4_LARGE = [RIGHT_LARGE_X, LOWER_LARGE_Y, *LARGE_ITEM]

  ITEM_LOCATIONS = {
    # p1_small: P1_SMALL,
    player_one: P1_LARGE,

    # p2_small: P2_SMALL,
    player_two: P2_LARGE,

    # p3_small: P3_SMALL,
    player_three: P3_LARGE,

    # p4_small: P4_SMALL,
    player_four: P4_LARGE,
  }

  ITEM_DETECTION_COORDS = {
    player_one: [[64,   32], [118,  47]],
    player_two: [[1214, 32], [1160, 47]],
    player_three: [[65, 392], [118, 407]],
    player_four: [[1214, 392], [1160, 407]],
  }

  def self.is_similar_colour?(px1, px2)
    hd_thr = 20
    s_thr = 120
    h1, s1, l1, _ = px1.to_hsla
    h2, s2, l2, _ = px2.to_hsla

    hd = (h1 - h2).abs
    sd = (s1 - s2).abs
    if hd < hd_thr || hd > (360 - hd_thr) # account for 360 edge
      if s1 > 120 && s2 > 120
        return true
      end
    end
    false
  end

  def self.get_corner_pixels(img, x, y, w, h)
    tl = [x, y]
    tr = [x + w, y]
    bl = [x + w, y]
    br = [x + w, y + h]

    [tl, tr, bl, br].map do |(x, y)|
      img.pixel_color(x, y)
    end
  end

  ITEM_THRESHOLDS = {
    'golden-mushroom' => 16,
    'star' => 16,
    'banana' => 15,
    'banana-double' => 15,
    'banana-triple' => 15,
    'coin' => 15,
    'mushroom-double' => 14,
    'pirhana-plant' => 14,
    'fire-flower' => 15,
    'bullet' => 14,
    'green-shell' => 14,
  }
  ITEM_THRESHOLDS.default = 13 # max

  ITEM_REFERENCES = Hash[
    Dir['reference_images/items/*.jpg'].map do |f|
      [File.basename(f, '.jpg'), Phashion::Image.new(f)]
    end.sort_by { |(n, _)| ITEM_THRESHOLDS[n] }
  ]

  def self.identify_item(phash_img)
    ITEM_REFERENCES.each do |name_variant, ref_img|
      dist = ref_img.distance_from(phash_img)
      name, variant = name_variant.split('_', 2)
      if dist < ITEM_THRESHOLDS[name]
        return name
      end
    end
    nil
  end

  def self.player_items(img, data)
    data = data.clone
    ITEM_DETECTION_COORDS.each do |player, detect_coords|
      pixels = detect_coords.map { |(x, y)| img.pixel_color(x, y).to_hsla }

      # Check 1: look for the whitest point of the highlight on the item circles
      if !pixels.all? { |(h, s, l, a)| l > 180 && s < 150 }
        next
      end

      # Check 2: make sure at least 3 the corner pixels are similar and over saturation of 50

      coords = ITEM_LOCATIONS[player]
      pixels = get_corner_pixels(img, *coords)
      first, *others = pixels
      count = others.count { |px| is_similar_colour?(first, px) }
      if count >= 2 && pixels.all? { |px| px.to_hsla[1] > 50 }

        # crop in so we have less background noise to deal with
        crop_delta = if coords.last == 34 # small
          [10, 10, -20, -20]
        else
          [15, 15, -30, -30]
        end

        inset_coords = coords.zip(crop_delta).map { |a, b| a + b}

        maybe_item_phash = convert_to_phash(img.crop(*inset_coords))

        data[player] ||= {}
        data[player][:item] = identify_item(maybe_item_phash)
      end
    end
    data
  end

end
