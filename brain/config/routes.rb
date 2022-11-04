# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount LeaguebotApi => '/api'

  get 'event', to: "application#index"
  get 'kartalytics_matches/:id', as: 'kartalytics_match', to: 'application#index'
  get 'leaderboard', to: "application#index"

  get 'players', to: "application#index"
  get 'players/:name', to: "application#index"

  get 'courses', to: "application#index"
  get 'courses/:name', to: "application#index"

  get 'edit_current_race', to: "application#edit_current_race"
  post 'update_current_race', to: "application#update_current_race"

  get 'kartalytics_races/audit', to: 'kartalytics_races#audit'
  patch 'kartalytics_races/:id', as: 'update_kartalytics_race', to: 'kartalytics_races#update'

  root 'application#index'
end
