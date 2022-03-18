require 'phashion'
require './screenshot'
require './screens/screen'
require './screens/intro_screen'

Dir['intro/*.jpg'].each do |filename|
  image = IntroScreen.prepare_image(Screenshot.new(filename))
  image.write("reference_images/#{filename}")
end
