require 'pry'

require './analyser'

# Known loading screen: 2017062119573200-16851BE00BC6068871FE49D98876D6C5.jpg

Dir.glob('./training-data/*.jpg').each do |filename|
  Analyser.analyse!(filename)
end