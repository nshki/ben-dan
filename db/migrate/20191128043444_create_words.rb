class CreateWords < ActiveRecord::Migration[6.0]
  def change
    create_table :words do |t|
      t.string :spelling

      t.timestamps
    end
  end
end
