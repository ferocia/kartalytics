class SelectCharacterScreen < Screen
  # Strat:
  #   Compare with reference
  REFERENCE = Phashion::Image.new('reference_images/select_character.jpg')

  def self.matches_image?(screenshot)
    image = screenshot.original.dup.crop!(793, 448, 44, 44)
    phash = convert_to_phash(image)
    phash.distance_from(REFERENCE) < 10
  end

  def self.extract_event(screenshot)
    {
      event_type: 'select_character_screen'
    }
  end
end
