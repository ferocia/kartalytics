require 'phashion'
require './screenshot'
require './screens/screen'
require './screens/intro_screen'
require './lib'

Dir['intro/*.jpg'].each do |filename|
  puts "file: #{filename}"
  screenshot = Screenshot.new(filename)
  # Lib.print_image(name: "screenshot", image: screenshot.original.dup.resize(640, 360, Magick::TriangleFilter))

  (variant, track) = IntroScreen.prepare_image(Screenshot.new(filename))

  # Lib.print_image(name: "variant", image: variant)
  # Lib.print_image(name: "track", image: track)

  track.write("reference_images/#{filename}")

  variant.destroy!
  track.destroy!
end
