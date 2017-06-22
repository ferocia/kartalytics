require 'bundler/setup'

require_relative '../kartalytics/final_result.rb'

RSpec.configure do |config|
  # TODO
end

def fixture(path)
  File.join File.dirname(__FILE__), 'fixtures', path
end
