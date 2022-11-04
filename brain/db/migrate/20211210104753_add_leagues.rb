class AddLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :leagues, id: false do |t|
      t.string :id, null: false, primary_key: true
      t.string :name, null: false
      t.timestamps
    end

    reversible do |direction|
      direction.up do
        Match.all.map(&:league_id).uniq.each do |league_id|
          League.create(id: league_id, name: league_id)
        end
      end
    end

    add_foreign_key :matches, :leagues
  end
end
