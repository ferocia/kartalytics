class AddRetiredToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :retired, :boolean
  end
end
