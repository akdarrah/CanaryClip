class CameraAngles::FullLeft < CameraAngle
  def camera
    camera_coordinate = {
      :x => (left_x + length_or_height_distance),
      :y => middle_y,
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
