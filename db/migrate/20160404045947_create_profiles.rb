class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :username
      t.string :uuid

      t.timestamps
    end
  end
end
