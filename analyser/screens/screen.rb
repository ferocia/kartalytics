class Screen
  TMPDIR = ENV.fetch("TMPDIR", "dump")
  def self.convert_to_phash(image)

    filename = ["tmp", Time.now.to_i, rand(1_000_000), "jpg"].join(".")
    path = "#{TMPDIR}/#{filename}"

    image.write(path)
    image.destroy!
    Phashion::Image.new(path)
  end
end
