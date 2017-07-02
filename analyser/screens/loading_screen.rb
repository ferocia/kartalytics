class LoadingScreen
  # Strat:
  #   Shrink the image right down
  #   Quantize to reduce color space
  #   If image is predominately white - it's a loading screen
  def self.matches_image?(screenshot)
    screenshot.original.get_pixels(20,0, 20, 1).all? do |pixel|
      pixel.red == pixel.green &&
        pixel.green == pixel.blue &&
        pixel.red > 61000
    end
  end

  def self.extract_event(screenshot)
    {
      event_type: 'loading_screen'
    }
  end
end
