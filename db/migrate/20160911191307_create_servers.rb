class CreateServers < ActiveRecord::Migration
  def change
    create_table :servers do |t|
      t.string :name, null: false
      t.string :permalink, null: false
      t.integer :owner_user_id, null: false
      t.integer :owner_character_id
      t.string :encrypted_authenticity_token, null: false
      t.text :description
      t.string :hostname, null: false
      t.boolean :claims_allowed, null: false, default: false

      t.timestamps
    end

    add_index :servers, :owner_user_id
    add_index :servers, :owner_character_id

    Server.create!(
      :name           => "Minebuild Official Minecraft Server",
      :owner_user     => User.find_by_email("piremies@gmail.com"),
      :hostname       => "45.35.171.145:25654",
      :claims_allowed => true
    )
  end
end
