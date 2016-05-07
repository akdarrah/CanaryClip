class CameraAngles::TopDown < CameraAngle
  def camera_and_focus_coordinates
    {
      :focus_coordinate  => {
        :x => middle_x,
        :y => top_y,
        :z => middle_z
      },
      :camera_coordinate => {
        :x => middle_x,
        :y => top_y + CAMERA_DISTANCE_FROM_SCHEMATIC,
        :z => middle_z
      }
    }
  end
end
