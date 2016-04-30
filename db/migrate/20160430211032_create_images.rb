class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :schematic_id

      t.timestamps
    end

    add_index :images, :schematic_id
    add_attachment :images, :file
  end
end
