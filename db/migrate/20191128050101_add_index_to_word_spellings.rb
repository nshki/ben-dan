class AddIndexToWordSpellings < ActiveRecord::Migration[6.0]
  def change
    add_index :words, :spelling
  end
end
