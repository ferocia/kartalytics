# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Leaderboard', type: :feature do
  it 'shows the leaderboard' do
    visit('/leaderboard')

    expect(page).to have_content("chris\n#1")
    expect(page).to have_content("tom\n#2")
    expect(page).to have_content("mike\n#3")
    expect(page).to have_content("raj\n#4")
    expect(page).to have_content("gt\n#5")
  end
end
