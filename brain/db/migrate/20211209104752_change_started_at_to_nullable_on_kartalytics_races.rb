class ChangeStartedAtToNullableOnKartalyticsRaces < ActiveRecord::Migration[6.1]
  def change
    change_column :kartalytics_races, :started_at, :datetime, null: true
  end
end
