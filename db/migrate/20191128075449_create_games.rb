class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.jsonb :board

      t.timestamps
    end
  end
end
