class CameraAngles::TopDown < CameraAngle
  def camera
    camera_coordinate = {
      :x => middle_x,
      :y => (top_y + width_or_length_distance),
      :z => middle_z
    }

    focus_coordinate = {
      :x => middle_x,
      :y => top_y,
      :z => middle_z
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
