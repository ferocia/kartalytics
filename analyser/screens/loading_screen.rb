class LoadingScreen
  # Strat:
  #   Shrink the image right down
  #   Quantize to reduce color space
  #   If image is predominately white - it's a loading screen
  def self.matches_image?(screenshot)
    pixel, frequency = screenshot.ten_px.quantize(16).color_histogram.to_a.sort do |a, b|
      b.last <=> a.last
    end.first

    hue, saturation, lightness = pixel.to_hsla

    frequency > 45 && hue == 0 && saturation == 0 && lightness > 240
  end

  def self.extract_event(screenshot)
    {
      event_type: 'loading_screen'
    }
  end
end
