class CreateFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :friends do |t|
      t.bigint :user_id
      t.bigint :friend_id
      t.boolean :confirmed

      t.timestamps
    end

    change_column_default :friends, :confirmed, from: nil, to: false

    add_index :friends, [:user_id, :friend_id], unique: true
    add_index :friends, [:friend_id, :user_id], unique: true
    add_index :friends, :confirmed
  end
end
