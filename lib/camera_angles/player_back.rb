class CameraAngles::PlayerBack < CameraAngle
  def camera_and_focus_coordinates
    back_z_point = SceneDirector::PASTE_Z + @schematic.analysis["Length"]

    camera_coordinate = {
      :x => SceneDirector::PASTE_X + (@schematic.analysis['Width'] / 2),
      :y => SceneDirector::CAMERA_Y,
      :z => (back_z_point + SceneDirector::CAMERA_DISTANCE)
    }

    optimistic_view_height = SceneDirector::CAMERA_Y + SceneDirector::CAMERA_VIEW_DELTA
    focus_height = if optimistic_view_height < @schematic.analysis["Height"]
                     optimistic_view_height
                   else
                     @schematic.analysis["Height"]
                   end

    focus_coordinate = {
      :x => camera_coordinate[:x],
      :y => focus_height,
      :z => back_z_point
    }

    {
      :focus_coordinate  => focus_coordinate,
      :camera_coordinate => camera_coordinate
    }
  end
end
