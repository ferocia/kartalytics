class IndexForeignKeysInPlayers < ActiveRecord::Migration[5.2]
  def change
    add_index :players, :slack_id
  end
end
