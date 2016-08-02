class AddStateToRenders < ActiveRecord::Migration
  def change
    add_column :renders, :state, :string, default: "pending", null: false
  end
end
