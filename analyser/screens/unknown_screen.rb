class UnknownScreen
  # for logging purposes only. MUST be processed last
  def self.matches_image?(screenshot)
    true
  end

  def self.extract_event(screenshot)
    # Ignore
  end
end
