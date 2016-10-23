class AddPositionToRenders < ActiveRecord::Migration
  def change
    add_column :renders, :position, :integer
    
    Schematic.all.each do |schematic|
      schematic.renders.camera_angle_order.each_with_index do |render, index|
        render.update_column :position, index+1
      end
    end
  end
end
