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

      centre_col_brightness <= 50
    end
  end

  def self.extract_event(screenshot)
    positions = extract_postions(screenshot.original)

    # No point sending event if no data
    unless positions.empty?
      {
        event_type: 'race_screen',
        data: positions
      }
    end
  end

  STARTING_CROPS = {
    player_one:   { x: 57, y: 239 },
    player_two:   { x: 1167, y: 239 },
    player_three: { x: 57, y: 599 },
    player_four:  { x: 1167, y: 599 }
  }

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
    {pos: 12, images: ["pos12.png"]},
  ].each do |ref|
    ref[:images] = ref[:images].map{|file| Phashion::Image.new("reference_images/race/#{file}") }
  end

  def self.extract_postions(image)
    result = {}
    STARTING_CROPS.each do |player, crop_xy|
      img = image.dup.crop(crop_xy[:x], crop_xy[:y], 36, 54).quantize(256, Magick::GRAYColorspace)

      phashion_image ||= begin
        file_path = '_tmp_delete_me.jpg'
        img.write(file_path)
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
