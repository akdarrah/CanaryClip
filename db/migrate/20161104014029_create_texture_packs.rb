class CreateTexturePacks < ActiveRecord::Migration
  def change
    create_table :texture_packs do |t|
      t.string :name
      t.string :permalink
      t.boolean :default, default: false, null: false

      t.timestamps
    end
    add_attachment :texture_packs, :zip_file

    add_column :schematics, :texture_pack_id, :integer
    add_index :schematics, :texture_pack_id

    add_column :renders, :texture_pack_id, :integer
    add_index :renders, :texture_pack_id

    texture_pack = TexturePack.create!(
      :name     => "Faithful",
      :zip_file => File.open("#{Rails.root}/test/files/Faithful.zip"),
      :default  => true
    )
    Render.update_all :texture_pack_id => texture_pack
    Schematic.update_all :texture_pack_id => texture_pack
  end
end
