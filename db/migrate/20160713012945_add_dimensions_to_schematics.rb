class AddDimensionsToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :width, :integer
    add_column :schematics, :length, :integer
    add_column :schematics, :height, :integer
  end
end
