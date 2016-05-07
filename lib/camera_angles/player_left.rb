class CameraAngles::PlayerLeft < CameraAngle
  def camera_and_focus_coordinates
    camera_coordinate = {
      :x => left_x + CAMERA_DISTANCE_FROM_SCHEMATIC,
      :y => PLAYER_POV_HEIGHT,
      :z => middle_z
    }

    focus_coordinate = {
      :x => left_x,
      :y => player_pov_y,
      :z => middle_z
    }

    # Reversed for left/right axis
    {
      :focus_coordinate  => camera_coordinate,
      :camera_coordinate => focus_coordinate
    }
  end
end
