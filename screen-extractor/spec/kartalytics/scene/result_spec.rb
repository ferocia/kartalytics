require 'spec_helper'

describe Kartalytics::Scene::Result do
  let(:image) { fixture 'images/result.jpg' }
  let(:final_result) { described_class.new(image) }
end
