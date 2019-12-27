class AddScoreToGameUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :game_users, :score, :int
    change_column_default :game_users, :score, 0
  end

  def down
    remove_column :game_users, :score
  end
end
