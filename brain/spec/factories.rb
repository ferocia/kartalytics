# frozen_string_literal: true

FactoryBot.define do
  factory :player do
  end

  factory :kartalytics_match do
  end

  factory :kartalytics_race do
    association :match, factory: :kartalytics_match
    association :course, factory: :kartalytics_course
    started_at { Time.zone.now }
  end

  factory :kartalytics_course do
    name { "Grumble Volcano" }
  end

  factory :kartalytics_race_snapshot do
    association :race, factory: :kartalytics_race
  end
end
