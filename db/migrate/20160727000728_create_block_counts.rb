class CreateBlockCounts < ActiveRecord::Migration
  def change
    create_table :block_counts do |t|
      t.integer :block_id, null: false
      t.integer :schematic_id, null: false
      t.integer :count, null: false, default: 0

      t.timestamps
    end

    add_index :block_counts, :block_id
    add_index :block_counts, :schematic_id
  end
end
