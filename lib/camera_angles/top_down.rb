class CameraAngles::TopDown < CameraAngle
  DISTANCE_FROM_SCHEMATIC = 10

  def camera_and_focus_coordinates
    middle_z_point = SceneDirector::PASTE_Z + (@schematic.analysis["Length"] / 2)

    camera_coordinate = {
      :x => SceneDirector::PASTE_X + (@schematic.analysis['Width'] / 2),
      :y => @schematic.analysis["Height"] + DISTANCE_FROM_SCHEMATIC,
      :z => middle_z_point
    }

    focus_coordinate = {
      :x => camera_coordinate[:x],
      :y => @schematic.analysis["Height"],
      :z => middle_z_point
    }

    {
      :focus_coordinate  => focus_coordinate,
      :camera_coordinate => camera_coordinate
    }
  end
end
