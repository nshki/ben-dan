class CreateGameUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :game_users do |t|
      t.bigint :user_id
      t.bigint :game_id

      t.timestamps
    end
  end
end
