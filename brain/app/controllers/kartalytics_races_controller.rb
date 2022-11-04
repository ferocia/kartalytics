# frozen_string_literal: true

class KartalyticsRacesController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def audit
    @courses = KartalyticsCourse.all.order(name: :asc)
    @races = KartalyticsRace.order(id: :desc).limit(360)

    render :audit, layout: false
  end

  def update
    race = KartalyticsRace.find_by(id: params[:id])
    prev_course = race.course
    next_course = KartalyticsCourse.find_by(name: params[:course])

    # if there's no detected image, the race time may be wildly incorrect; the
    # analyser may have started capturing mid-way through a race. we can't allow
    # the course to be reassigned as it may assign an impossible course record.
    if race.detected_image.nil?
      return redirect_to kartalytics_races_audit_path, alert: "Can't update course for race #{race.id} as start time is invalid"
    end

    race.update_course(next_course)
    ::Slack.notify(":alert: match##{race.match.id} race##{race.id} course manually reassigned from #{prev_course.name} to #{next_course.name}")

    redirect_to kartalytics_races_audit_path
  end
end
