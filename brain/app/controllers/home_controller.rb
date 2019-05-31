# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @matches = if params[:show_all]
      (KartalyticsMatch.all.order('created_at DESC') - [KartalyticsMatch.current_match])
    else
      (KartalyticsMatch.all.order('created_at DESC').limit(50) - [KartalyticsMatch.current_match])
    end
  end
end
