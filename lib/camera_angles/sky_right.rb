# TODO: Fix this
class CameraAngles::SkyRight < CameraAngle
  MIN_CAMERA_HEIGHT = 10

  def camera_and_focus_coordinates
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

    mid_z = SceneDirector::PASTE_Z + (@schematic.analysis["Length"] / 2)

    camera_coordinate = {
      :x => SceneDirector::PASTE_X - SceneDirector::CAMERA_DISTANCE,
      :y => camera_height,
      :z => mid_z
    }

    focus_coordinate = {
      :x => SceneDirector::PASTE_X,
      :y => focus_height,
      :z => mid_z
    }

    # Reversed for left/right axis
    {
      :focus_coordinate  => camera_coordinate,
      :camera_coordinate => focus_coordinate
    }
  end
end
