class CameraAngles::SkyBack < CameraAngle
  MIN_CAMERA_HEIGHT = 10

  def camera_and_focus_coordinates
    back_z_point = SceneDirector::PASTE_Z + @schematic.analysis["Length"]

    camera_height = if @schematic.analysis["Height"] < MIN_CAMERA_HEIGHT
                      MIN_CAMERA_HEIGHT
                    else
                      @schematic.analysis["Height"]
                    end

    optimistic_view_height = @schematic.analysis["Height"] - SceneDirector::CAMERA_VIEW_DELTA
    focus_height = if optimistic_view_height < SceneDirector::PASTE_Y
                     @schematic.analysis["Height"]
                   else
                     optimistic_view_height
                   end

    camera_coordinate = {
      :x => SceneDirector::PASTE_X + (@schematic.analysis['Width'] / 2),
      :y => camera_height,
      :z => (back_z_point + SceneDirector::CAMERA_DISTANCE)
    }

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
