class CreateCharacterClaims < ActiveRecord::Migration
  def change
    create_table :character_claims do |t|
      t.integer :user_id
      t.integer :character_id
      t.string :character_username
      t.string :token
      t.string :state

      t.timestamps
    end
    
    add_index :character_claims, :user_id
    add_index :character_claims, :character_id
  end
end
