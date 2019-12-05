class AddTileBagToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :tile_bag, :string, array: true, default: []
  end
end
