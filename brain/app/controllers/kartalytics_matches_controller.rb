# frozen_string_literal: true

class KartalyticsMatchesController < ApplicationController
  def show
    @match = KartalyticsMatch.find(params[:id])
  end

  def event
    render layout: false
  end
end
