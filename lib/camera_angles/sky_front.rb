class CameraAngles::SkyFront < CameraAngle
  def camera_and_focus_coordinates
    camera_coordinate = {
      :x => SceneDirector::PASTE_X + (@schematic.analysis['Width'] / 2),
      :y => @schematic.analysis["Height"],
      :z => (SceneDirector::PASTE_Z - SceneDirector::CAMERA_DISTANCE)
    }

    optimistic_view_height = @schematic.analysis["Height"] - SceneDirector::CAMERA_VIEW_DELTA
    focus_height = if optimistic_view_height < SceneDirector::PASTE_Y
                     SceneDirector::PASTE_Y + SceneDirector::CAMERA_VIEW_DELTA # TODO
                   else
                     optimistic_view_height
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
