# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Menu', type: :feature do
  it 'can navigate using the menu' do
    visit('/')

    click_menu_link('Home')

    click_menu_link('Event')
    expect(page).to have_content('Course Statistics')

    click_menu_link('Players')
    expect(page).to have_content('andrew')

    click_menu_link('Leaderboard')
    expect(page).to have_content("chris")

    # click_menu_link('Courses')
    # expect(page).to have_content('Turnip Cup')
  end

  def click_menu_link(link)
    find('[role="button"][title="Menu"]').click # capybara doesn't like role 🤔
    click_link(link)
  end
end
