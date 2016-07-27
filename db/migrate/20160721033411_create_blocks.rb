class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :minecraft_id
      t.string :name
      t.string :display_name
      t.integer :stack_size
      t.boolean :diggable
      t.string :bounding_box
      t.boolean :transparent
      t.integer :emit_light
      t.integer :filter_light
      t.string :material

      t.timestamps
    end

    add_column :blocks, :hardness, :decimal, :precision => 4, :scale => 1
    add_index :blocks, :minecraft_id
    add_attachment :blocks, :icon
  end
end
