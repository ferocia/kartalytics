class MainMenuScreen
  # Strat:
  #   Compare with reference
  REFERENCE = Phashion::Image.new("reference_images/main_menu.jpg")

  def self.matches_image?(screenshot)
    crop = screenshot.original.dup.crop!(220, 467, 122, 24)
    img = crop.white_threshold(35000, 35000, 35000)

    file_path = 'tmp.jpg'

    img.write(file_path)

    img.destroy!
    crop.destroy!

    phash = Phashion::Image.new(file_path)

    phash.distance_from(REFERENCE) < 10
  end

  def self.extract_event(screenshot)
    {
      event_type: 'main_menu_screen'
    }
  end
end
