class AddStateToSchematics < ActiveRecord::Migration
  def change
    add_column :schematics, :state, :string
  end
end
