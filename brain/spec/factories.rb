# frozen_string_literal: true

FactoryBot.define do
  factory :player do
    name { "bilbo" }
  end

  factory :league do
    id { '123' }
    name { 'kart' }
  end

  factory :match do
    league_id { '123' }
    players_in_order { "neil, langers, steve, tom" }
  end

  factory :kartalytics_match do
    player_count          { 4 }
    player_one_score      { 10 }
    player_two_score      { 9 }
    player_three_score    { 9 }
    player_four_score     { 42 }
    player_one_position   { 4 }
    player_two_position   { 6 }
    player_three_position { 7 }
    player_four_position  { 2 }
    player_one_order      { 1 }
    player_two_order      { 2 }
    player_three_order    { 3 }
    player_four_order     { 0 }
    status                { 'finished' }
  end

  factory :entered_race do
    association :player
    association :course, factory: :kartalytics_course
    association :race, factory: :kartalytics_race
    association :kartalytics_match
  end

  factory :entered_match do
    association :player
    association :kartalytics_match
  end

  factory :kartalytics_race do
    association :match, factory: :kartalytics_match
    association :course, factory: :kartalytics_course
    started_at { Time.zone.now }
  end

  factory :kartalytics_course do
    name { "Grumble Volcano (Wii)" }
  end

  factory :kartalytics_race_snapshot do
    association :race, factory: :kartalytics_race
    timestamp { Time.zone.now }
  end
end
