# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
    render html: '', layout: true
  end

  def edit_current_race
    @courses = KartalyticsCourse.all.order(name: :asc)
    render :edit_current_race, layout: false
  end

  def update_current_race
    course = KartalyticsCourse.find_by(name: params[:course])
    KartalyticsState.instance.current_race&.update(course: course)

    redirect_to edit_current_race_path
  end
end
