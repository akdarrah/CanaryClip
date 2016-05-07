class CameraAngles::PlayerFront < CameraAngle
  def camera_and_focus_coordinates
    {
      :focus_coordinate  => {
        :x => middle_x,
        :y => player_pov_y,
        :z => close_z
      },
      :camera_coordinate => {
        :x => middle_x,
        :y => PLAYER_POV_HEIGHT,
        :z => (close_z - CAMERA_DISTANCE_FROM_SCHEMATIC)
      }
    }
  end
end
