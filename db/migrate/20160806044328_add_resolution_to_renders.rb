class AddResolutionToRenders < ActiveRecord::Migration
  def change
    add_column :renders, :resolution, :string
    Render.update_all resolution: "1024x768"
  end
end
