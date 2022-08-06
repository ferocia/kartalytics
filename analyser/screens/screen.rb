class Screen
  TMPDIR = ENV.fetch("TMPDIR", "dump")
  def self.convert_to_phash(image)
    image.write("#{TMPDIR}/tmp.jpg")
    image.destroy!
    Phashion::Image.new("#{TMPDIR}/tmp.jpg")
  end
end
