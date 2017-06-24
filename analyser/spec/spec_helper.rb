require 'bundler/setup'
require 'pry'

require_relative '../analyser.rb'

RSpec.configure do |config|
  config.color = true
end

def fixture_image(path)
  Magick::Image.read(fixture(path)).first
end

def fixture(path)
  File.join File.dirname(__FILE__), 'fixtures', path
end
