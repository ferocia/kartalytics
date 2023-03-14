require 'phashion'
require './screenshot'
require './screens/screen'
require './screens/intro_screen'
require './lib'

Dir['intro/mario_circuit*.jpg'].each do |filename|
  puts "Testing: #{filename}"

  screenshot = Screenshot.new(filename)

  Lib.print_image(name: filename, image: screenshot.original.dup.resize(640, 360))

  puts IntroScreen.extract_event(screenshot)

  screenshot.destroy!
end
