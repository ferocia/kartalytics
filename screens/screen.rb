class Screen
  def self.convert_to_phash(image)
    image.write('dump/tmp.jpg')
    image.destroy!
    Phashion::Image.new('dump/tmp.jpg')
  end
end