class AddCurrentTurnToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :current_turn_user_id, :bigint
  end
end
