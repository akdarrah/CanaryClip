class CameraAngles::PlayerBack < CameraAngle
  def camera
    camera_coordinate = {
      :x => middle_x,
      :y => PLAYER_POV_HEIGHT,
      :z => far_z + CAMERA_DISTANCE_FROM_SCHEMATIC
    }

    focus_coordinate = {
      :x => middle_x,
      :y => player_pov_y,
      :z => far_z
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
