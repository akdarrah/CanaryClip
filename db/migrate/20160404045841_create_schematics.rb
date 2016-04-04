class CreateSchematics < ActiveRecord::Migration
  def change
    create_table :schematics do |t|
      t.string :name

      t.timestamps
    end
  end
end
