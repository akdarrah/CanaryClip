class CreateTrackedDownloads < ActiveRecord::Migration
  def change
    create_table :tracked_downloads do |t|
      t.integer :schematic_id
      t.integer :character_id

      t.timestamps
    end

    add_index :tracked_downloads, :schematic_id
    add_index :tracked_downloads, :character_id
  end
end
