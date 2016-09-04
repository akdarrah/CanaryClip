class AddDescriptionToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :description, :text
  end
end
