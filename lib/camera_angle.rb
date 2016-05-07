class CameraAngle
  # TODO: It would be cool if we could calculate this to
  # optimize the amount of the schematic that is visible.
  CAMERA_DISTANCE_FROM_SCHEMATIC = 15

  PLAYER_POV_HEIGHT = 6
  PLAYER_POV_DELTA  = 5

  attr_accessor :schematic
  attr_accessor :right_x, :middle_x, :left_x
  attr_accessor :bottom_y, :middle_y, :top_y
  attr_accessor :close_z, :middle_z, :far_z
  attr_accessor :player_pov_y

  def initialize(schematic)
    self.schematic = schematic

    calculate_schematic_positions
  end

  def camera_and_focus_coordinates
    raise NotImplementedError
  end

  private

  def calculate_schematic_positions
    self.right_x  = SceneDirector::PASTE_X
    self.middle_x = SceneDirector::PASTE_X + (@schematic.analysis['Width'] / 2)
    self.left_x   = SceneDirector::PASTE_X + @schematic.analysis['Width']

    self.bottom_y = SceneDirector::PASTE_Y
    self.middle_y = SceneDirector::PASTE_Y + (@schematic.analysis['Height'] / 2)
    self.top_y    = SceneDirector::PASTE_Y + @schematic.analysis['Height']

    self.close_z  = SceneDirector::PASTE_Z
    self.middle_z = SceneDirector::PASTE_Z + (@schematic.analysis['Length'] / 2)
    self.far_z    = SceneDirector::PASTE_Z + @schematic.analysis['Length']

    optimistic_view_height = PLAYER_POV_HEIGHT + PLAYER_POV_DELTA
    self.player_pov_y = if optimistic_view_height < @schematic.analysis["Height"]
                          optimistic_view_height
                        else
                          @schematic.analysis["Height"]
                        end
  end

end
