class MatchResultScreen
  # Strat:
  #   Compare with reference
  REFERENCE = Phashion::Image.new("reference_images/match_result/reference.jpg")

  def self.matches_image?(screenshot)
    crop = screenshot.original.dup.crop!(141, 63, 72, 56)
    img = crop.black_threshold(50000, 50000, 50000)

    file_path = '_tmp_delete_me.jpg'

    img.write(file_path)

    img.destroy!
    crop.destroy!

    phash = Phashion::Image.new(file_path)

    phash.distance_from(REFERENCE) < 10
  end

  def self.extract_event(screenshot)
    {
      event_type: 'match_result_screen'
    }
  end
end
