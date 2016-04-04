class CreateSchematics < ActiveRecord::Migration
  def change
    create_table :schematics do |t|
      t.string :name, null: false
      t.integer :profile_id, null: false
      t.string :permalink

      t.timestamps
    end

    add_index :schematics, :profile_id
    add_index :schematics, :permalink
    add_attachment :schematics, :file
  end
end
