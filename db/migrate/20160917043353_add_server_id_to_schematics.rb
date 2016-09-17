class AddServerIdToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :server_id, :integer
    add_index :schematics, :server_id
    
    server = Server.first
    Schematic.update_all :server_id => server
  end
end
