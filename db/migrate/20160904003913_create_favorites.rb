class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :schematic_id, null: false
      t.integer :character_id, null: false

      t.timestamps
    end
    
    add_index :favorites, :schematic_id
    add_index :favorites, :character_id
  end
end
