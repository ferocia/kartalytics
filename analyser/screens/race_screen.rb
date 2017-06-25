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

    # quadrants = [
    #   screenshot.working.dup.crop(0,0,150,84)
    # ]
    # extract_postions!()
    extract_postions(screenshot.original)
    {
      event_type: 'race_screen'
    }
  end

  STARTING_CROPS = {
    player_one:   { x: 57, y: 239 },
    player_two:   { x: 1167, y: 239 },
    player_three: { x: 57, y: 598 },
    # player_four:  { x: 1167, y: 598 }
  }

  REFERENCE_IMAGES = [
    {pos: 1,  image: Phashion::Image.new("reference_images/race/pos1.png")},
    {pos: 2,  image: Phashion::Image.new("reference_images/race/pos2.png")},
    {pos: 3,  image: Phashion::Image.new("reference_images/race/pos3.png")},
    {pos: 4,  image: Phashion::Image.new("reference_images/race/pos4.png")},
    {pos: 5,  image: Phashion::Image.new("reference_images/race/pos5.png")},
    {pos: 6,  image: Phashion::Image.new("reference_images/race/pos6.png")},
    {pos: 7,  image: Phashion::Image.new("reference_images/race/pos7.png")},
    {pos: 8,  image: Phashion::Image.new("reference_images/race/pos8.png")},
    {pos: 9,  image: Phashion::Image.new("reference_images/race/pos9.png")},
    {pos: 10, image: Phashion::Image.new("reference_images/race/pos10.png")},
    {pos: 11, image: Phashion::Image.new("reference_images/race/pos11.png")},
    {pos: 12, image: Phashion::Image.new("reference_images/race/pos12.png")},
  ]

  def self.extract_postions(image)

    STARTING_CROPS.each do |player, crop_xy|
      img = image.dup.crop(crop_xy[:x], crop_xy[:y], 36, 54).quantize(256, Magick::GRAYColorspace)

      phashion_image ||= begin
        file_path = '_tmp_delete_me.jpg'
        img.write(file_path)
        Phashion::Image.new(file_path)
      end

      pos = REFERENCE_IMAGES.min_by do |reference|
        phashion_image.distance_from(reference[:image])
      end

      img.quantize(256, Magick::GRAYColorspace).write("tmp-#{pos[:pos]}-distance-#{phashion_image.distance_from(pos[:image])}-#{player}-#{rand(256)}.png")
    end

    # Mask offset p1/
    # X 41px
    # Y 236px

    # p3
    # X 41px

  end
end
