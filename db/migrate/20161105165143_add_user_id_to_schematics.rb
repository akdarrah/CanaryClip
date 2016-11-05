class AddUserIdToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :user_id, :integer
    add_index :schematics, :user_id
  end
end
