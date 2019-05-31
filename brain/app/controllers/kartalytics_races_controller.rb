# frozen_string_literal: true

class KartalyticsRacesController < ApplicationController
  def show
    @race = KartalyticsRace.find(params[:id])
    render partial: 'kartalytics_matches/race', object: @race
  end
end
