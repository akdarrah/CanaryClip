class FixRenderPositionScope < ActiveRecord::Migration
  def change
    
    Schematic.all.each do |schematic|
      schematic.renders.standard_resolution.camera_angle_order.each_with_index do |render, index|
        render.update_column :position, index+1
      end
      
      schematic.renders.high_resolution.camera_angle_order.each_with_index do |render, index|
        render.update_column :position, index+1
      end
    end
    
  end
end
