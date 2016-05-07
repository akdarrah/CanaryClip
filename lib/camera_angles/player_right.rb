class CameraAngles::PlayerRight < CameraAngle
  def camera
    camera_coordinate = {
      :x => right_x - CAMERA_DISTANCE_FROM_SCHEMATIC,
      :y => PLAYER_POV_HEIGHT,
      :z => middle_z
    }

    focus_coordinate = {
      :x => right_x,
      :y => player_pov_y,
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
