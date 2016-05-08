class CameraAngles::SkyFront < CameraAngle
  def camera
    camera_coordinate = {
      :x => middle_x,
      :y => sky_cam_height,
      :z => close_z - CAMERA_DISTANCE_FROM_SCHEMATIC
    }

    focus_coordinate = {
      :x => middle_x,
      :y => middle_y,
      :z => close_z
    }

    {
      :x     => camera_coordinate[:x],
      :y     => camera_coordinate[:y],
      :z     => camera_coordinate[:z],
      :pitch => pitch(focus_coordinate, camera_coordinate),
      :yaw   => yaw(focus_coordinate, camera_coordinate)
    }
  end
end
