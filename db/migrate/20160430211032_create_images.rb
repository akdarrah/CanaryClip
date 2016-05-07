class CreateImages < ActiveRecord::Migration
  def change
    create_table :renders do |t|
      t.integer :schematic_id
      t.string :camera_angle
      t.integer :samples_per_pixel

      t.timestamps
    end

    add_index :renders, :schematic_id
    add_attachment :renders, :file
  end
end
