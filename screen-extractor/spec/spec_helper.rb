require 'bundler/setup'

require_relative '../kartalytics/final_result.rb'
require_relative '../kartalytics/score_block.rb'

RSpec.configure do |config|
  config.color = true
end

def fixture(path)
  File.join File.dirname(__FILE__), 'fixtures', path
end
