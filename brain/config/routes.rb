# frozen_string_literal: true

Rails.application.routes.draw do
  mount LeaguebotAPI => '/api'
  resources :kartalytics_matches
  resources :kartalytics_races, only: [:show]

  get 'event', to: "kartalytics_matches#event"
  root 'kartalytics_matches#event'
end
