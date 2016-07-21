class AddParsedNbtDataToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :parsed_nbt_data, :text, default: {}.to_json
  end
end
