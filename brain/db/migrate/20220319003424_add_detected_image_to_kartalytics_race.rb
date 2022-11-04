class AddDetectedImageToKartalyticsRace < ActiveRecord::Migration[6.1]
  def change
    add_column :kartalytics_races, :detected_image, :binary
  end
end
