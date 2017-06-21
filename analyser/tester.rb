require 'pry'

require './analyser'

glob = './training-data/*.jpg'


# Known loading screen: 2017062119573200-16851BE00BC6068871FE49D98876D6C5.jpg
# Known race screen: 2017062119575600-16851BE00BC6068871FE49D98876D6C5.jpg
# glob = './training-data/2017062119575600-16851BE00BC6068871FE49D98876D6C5.jpg'

Dir.glob(glob).each do |filename|
  Analyser.analyse!(filename)
end