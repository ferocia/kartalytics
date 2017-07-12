class FastIgnore
  # Ignore files < 20kb
  def self.matches_image?(screenshot)
    File.size(screenshot.filename) < 20_000
  end

  def self.extract_event(screenshot)
    # Ignore
  end
end