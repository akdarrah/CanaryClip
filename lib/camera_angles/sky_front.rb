class CameraAngles::SkyFront < CameraAngle
  def camera_and_focus_coordinates
    {
      :focus_coordinate  => {
        :x => middle_x,
        :y => sky_cam_y,
        :z => close_z
      },
      :camera_coordinate => {
        :x => middle_x,
        :y => sky_cam_height,
        :z => close_z - CAMERA_DISTANCE_FROM_SCHEMATIC
      }
    }
  end
end
