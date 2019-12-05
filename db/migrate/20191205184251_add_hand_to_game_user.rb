class AddHandToGameUser < ActiveRecord::Migration[6.0]
  def change
    add_column :game_users, :hand, :string, array: true, default: []
  end
end
