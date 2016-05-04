class CameraAngles::PlayerFront < CameraAngle
  def camera_and_focus_coordinates
    camera_coordinate = {
      :x => SceneDirector::PASTE_X + (@schematic.analysis['Width'] / 2),
      :y => SceneDirector::CAMERA_Y,
      :z => (SceneDirector::PASTE_Z - SceneDirector::CAMERA_DISTANCE)
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
      :z => SceneDirector::PASTE_Z
    }

    {
      :focus_coordinate  => focus_coordinate,
      :camera_coordinate => camera_coordinate
    }
  end
end
