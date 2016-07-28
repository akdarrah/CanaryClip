class RemoveNameFromSchematics < ActiveRecord::Migration
  def change
    remove_column :schematics, :name
  end
end
