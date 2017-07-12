class RaceScreen
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

      img.write("tmp.jpg")
      img.destroy!
      phash = Phashion::Image.new('tmp.jpg')

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

      phashion_image ||= begin
        file_path = '_tmp_delete_me.jpg'
        img.write(file_path)
        img.destroy!
        Phashion::Image.new(file_path)
      end


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
end
