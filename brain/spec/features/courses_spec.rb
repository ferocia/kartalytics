# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Courses', type: :feature do
  it 'shows a list of courses' do
    visit('/courses')

    expect(page).to have_link('Grumble Volcano (Wii)')

    fill_in('Search by course name', with: 'mike')
    expect(page).to have_no_link('Grumble Volcano (Wii)')

    fill_in('Search by course name', with: 'grum')
    expect(page).to have_link('Grumble Volcano (Wii)')

    click_link('Grumble Volcano (Wii)')
    expect(page).to have_content('Top Times')
    expect(page).to have_content('Top Players')
  end
end
