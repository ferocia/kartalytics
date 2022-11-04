# frozen_string_literal: true

namespace :races do
  desc 'Prunes elderly detected images from the db'

  # these images are used for auditing purposes; the analyser gets confused for
  # courses that don't have a reference image, which is a problem for new cups.
  # however, keeping them around forever is wasteful. think of the turtles 🐢
  task prune_detected_images: :environment do
    races = KartalyticsRace.where.not(detected_image: nil).order(id: :desc).offset(360)

    races.each do |race|
      race.update(detected_image: nil)
    end
  end
end
