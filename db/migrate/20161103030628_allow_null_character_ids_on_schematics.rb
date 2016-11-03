class AllowNullCharacterIdsOnSchematics < ActiveRecord::Migration
  def change
    change_column :schematics, :character_id, :integer, :null => true
  end
end
