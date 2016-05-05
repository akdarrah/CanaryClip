class CameraAngles::PlayerRight < CameraAngle
  def camera_and_focus_coordinates
    mid_z = SceneDirector::PASTE_Z + (@schematic.analysis["Length"] / 2)

    camera_coordinate = {
      :x => SceneDirector::PASTE_X + SceneDirector::CAMERA_DISTANCE,
      :y => SceneDirector::CAMERA_Y,
      :z => mid_z
    }

    optimistic_view_height = SceneDirector::CAMERA_Y + SceneDirector::CAMERA_VIEW_DELTA
    focus_height = if optimistic_view_height < @schematic.analysis["Height"]
                     optimistic_view_height
                   else
                     @schematic.analysis["Height"]
                   end

    focus_coordinate = {
      :x => SceneDirector::PASTE_X,
      :y => focus_height,
      :z => mid_z
    }

    # Reversed for left/right axis
    {
      :focus_coordinate  => focus_coordinate,
      :camera_coordinate => camera_coordinate
    }
  end
end
