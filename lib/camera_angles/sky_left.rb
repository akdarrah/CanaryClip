class CameraAngles::SkyLeft < CameraAngle
  def camera
    camera_coordinate = {
      :x => left_x + CAMERA_DISTANCE_FROM_SCHEMATIC,
      :y => sky_cam_height,
      :z => middle_z
    }

    focus_coordinate = {
      :x => left_x,
      :y => middle_y,
      :z => middle_z
    }

    {
      :x     => camera_coordinate[:x],
      :y     => camera_coordinate[:y],
      :z     => camera_coordinate[:z],
      :pitch => pitch(camera_coordinate, focus_coordinate),
      :yaw   => yaw(camera_coordinate, focus_coordinate)
    }
  end
end
