require 'pry'

require './analyser'

# glob = './training-data/*.jpg'


# # Known loading screen: 2017062119573200-16851BE00BC6068871FE49D98876D6C5.jpg
# # Known race screen: 2017062119575600-16851BE00BC6068871FE49D98876D6C5.jpg
# # glob = './training-data/2017062120142700-16851BE00BC6068871FE49D98876D6C5.jpg'

# `rm -rf ./classified/**/*.jpg`

# Dir.glob(glob).each do |filename|
#   Analyser.analyse!(filename)
# end

# Make masks for intro screens



Dir.glob('./introscreens/*.jpg').each_with_index do |screen, index|
  file = Magick::Image.read(screen).first

  file.crop(350, 620, 350, 36).black_threshold(50000, 50000, 50000).write("#{index}.jpg")
end