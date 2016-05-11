class CameraAngles::FullBack < CameraAngle
  def camera
    camera_coordinate = {
      :x => middle_x,
      :y => middle_y,
      :z => (far_z + width_or_height_distance)
    }

    focus_coordinate = {
      :x => middle_x,
      :y => middle_y,
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
