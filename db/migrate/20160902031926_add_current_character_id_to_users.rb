class AddCurrentCharacterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_character_id, :integer
    add_index :users, :current_character_id
  end
end
