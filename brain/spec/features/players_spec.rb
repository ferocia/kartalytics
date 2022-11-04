# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Players', type: :feature do
  it 'shows a list of players' do
    visit('/players')

    expect(page).to have_content('andrew')
    expect(page).to have_content('langers')

    fill_in('Search by player name', with: 'mike')
    expect(page).not_to have_content('andrew')
    expect(page).not_to have_content('langers')

    click_link('mike')
    expect(page).to have_content('mike')
    expect(page).to have_content("Total matches:\n0")
    expect(page).to have_content("Average score:\n0")
  end
end
