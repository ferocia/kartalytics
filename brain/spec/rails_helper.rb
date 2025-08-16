# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.default_driver = ENV.fetch('DEFAULT_DRIVER', 'selenium_chrome_headless').to_sym

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  # config.infer_spec_type_from_file_location!

  config.before(:suite) do
    KartalyticsMatch.destroy_all
    Player.delete_all
    Match.delete_all
    League.delete_all
    KartalyticsRace.delete_all
    KartalyticsCourse.delete_all

    FactoryBot.create(:player, name: 'chris')
    FactoryBot.create(:player, name: 'gt')
    FactoryBot.create(:player, name: 'langers')
    FactoryBot.create(:player, name: 'tom', slack_id: 'UT0M666')
    FactoryBot.create(:player, name: 'raj')
    FactoryBot.create(:player, name: 'mike')
    FactoryBot.create(:player, name: 'jared')
    FactoryBot.create(:player, name: 'josh')
    FactoryBot.create(:player, name: 'christian')
    FactoryBot.create(:player, name: 'wernah')
    FactoryBot.create(:player, name: 'andrew')
    FactoryBot.create(:player, name: 'carson')
    FactoryBot.create(:player, name: 'samii')

    League.create(id: '123', name: 'kart')
    ::Match.create_for!('123', %w[chris gt tom raj])
    ::Match.create_for!('123', %w[chris tom gt raj])
    ::Match.create_for!('123', %w[chris raj tom gt])
    ::Match.create_for!('123', %w[chris mike tom gt])

    League.create(id: 'ABC', name: 'ABC')
    ::Match.create_for!('ABC', %w[jared josh])
    ::Match.create_for!('ABC', %w[jared josh])
    ::Match.create_for!('ABC', %w[jared josh])

    League.create(id: 'LargeLeague', name: 'LargeLeague')
    ::Match.create_for!('LargeLeague', %w[
      chris gt langers tom
      raj mike jared josh
      christian wernah andrew carson
      samii
    ])

    ::Match.create_for!('LargeLeague', %w[christian gt langers tom])
    ::Match.create_for!('LargeLeague', %w[christian gt langers tom])
    ::Match.create_for!('LargeLeague', %w[christian gt langers tom])
    ::Match.create_for!('LargeLeague', %w[christian gt langers tom])
    ::Match.create_for!('LargeLeague', %w[christian gt langers tom])


    course = FactoryBot.create(:kartalytics_course)

    kartalytics_match = FactoryBot.create(:kartalytics_match, status: 'finished')

    FactoryBot.create(:kartalytics_race,
      match:                    kartalytics_match,
      course:                   course,
      started_at:               12.minutes.ago,
      status:                   'finished',
      player_one_position:      4,
      player_two_position:      3,
      player_three_position:    2,
      player_four_position:     1,
      player_one_score:         2,
      player_two_score:         5,
      player_three_score:       8,
      player_four_score:        13
    )

    FactoryBot.create(:kartalytics_race,
      match:                    kartalytics_match,
      course:                   course,
      started_at:               7.minutes.ago,
      status:                   'finished',
      player_one_position:      1,
      player_two_position:      2,
      player_three_position:    3,
      player_four_position:     4,
      player_one_score:         15,
      player_two_score:         12,
      player_three_score:       9,
      player_four_score:        1
    )

    FactoryBot.create(:kartalytics_race,
      match:                    kartalytics_match,
      course:                   course,
      started_at:               2.minutes.ago,
      status:                   'in_progress'
    )
  end
end
