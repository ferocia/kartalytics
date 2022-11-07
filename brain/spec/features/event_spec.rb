# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Event', type: :feature do
  before do
    ingest(event_type: 'main_menu_screen')
  end

  it 'shows the current match in real-time' do
    Timecop.travel(6.minutes.ago) # need to travel back for KartalyticsMatch.recent_unassigned_for
    visit('/event')

    ingest(event_type: 'select_character_screen')

    %w[chris tom samii mike].each_with_index do |player, index|
      click_button("Player #{index + 1}")
      click_link(player)
      expect(page).to have_content(player)
    end

    4.times do |index|
      ingest(event_type: 'intro_screen', data: { course_name: 'Big Blue' })
      expect(page).to have_content('Big Blue')
      expect(page).to have_content("Race #{index + 1}")
      expect(page).not_to have_content('Live Graph')
      expect(page).to have_content('Top Times')
      expect(page).to have_content('Top Players')

      ingest(
        event_type: 'race_screen',
        data: {
          player_one: { position: 3 },
          player_two: { position: 7 },
          player_three: { position: 1 },
          player_four: { position: 2 },
        }
      )
      expect(page).to have_content('Live Graph')
      expect(page).not_to have_content('Top Times')
      expect(page).not_to have_content('Top Players')

      ingest(
        event_type: 'race_result_screen',
        data: {
          player_one: { position: 12, points: 1 },
          player_two: { position: 6, points: 7 },
          player_three: { position: 2, points: 12 },
          player_four: { position: 8, points: 5 },
        }
      )
    end

    Timecop.travel(6.minutes.from_now)

    ingest(
      event_type: 'match_result_screen',
      data: {
        player_one: { position: 8, score: 23 },
        player_two: { position: 2, score: 62 },
        player_three: { position: 1, score: 90 },
        player_four: { position: 5, score: 46 },
      }
    )

    # simulate the scores being sent to slack
    Match.create_for!(League.id_for('kart'), KartalyticsMatch.last.player_names_in_order)

    expect(page).to have_content('Congratulations!')
    expect(page).to have_content("1\n👑\nsamii\n48 pts")
    expect(page).to have_content("2\ntom\n28 pts")
    expect(page).to have_content("5\nmike\n20 pts")
    expect(page).to have_content("8\nchris\n4 pts")
  end

  it 'can reassign players mid-match' do
    visit('/event')

    ingest(event_type: 'intro_screen', data: { course_name: 'New York Minute (Tour)' })
    expect(page).to have_content('New York Minute (Tour)')
    expect(page).to have_content('Race 1')

    ingest(
      event_type: 'race_screen',
      data: {
        player_one: { position: 3 },
        player_two: { position: 7 },
        player_three: { position: 1 },
        player_four: { position: 2 },
      }
    )
    expect(page).to have_content('Live Graph')

    %w[samii mike tom chris].each_with_index do |player, index|
      find('div[role="button"]', text: ::KartalyticsMatch::PLAYERS[index].to_s.humanize).click
      click_button("Player #{index + 1}")
      click_link(player)

      expect(page).to have_content('Live Graph')
      expect(page).to have_content(player)
    end
  end

  def ingest(**args)
    KartalyticsState.ingest(timestamp: Time.zone.now.iso8601, **args)
  end
end
