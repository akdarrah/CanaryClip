class CameraAngle
  # TODO: It would be cool if we could calculate this to
  # optimize the amount of the schematic that is visible.
  CAMERA_DISTANCE_FROM_SCHEMATIC = 15

  PRIMARY   = 'sky_front'
  SECONDARY = [
    'player_back', 'player_front', 'player_left', 'player_right',
    'sky_back', 'sky_left', 'sky_right', 'top_down'
  ]
  AVAILABLE = Array(PRIMARY) + SECONDARY

  CAMERA_DELTA      = 5
  PLAYER_POV_HEIGHT = 6
  MIN_SKY_POV       = 10

  attr_accessor :schematic
  attr_accessor :right_x, :middle_x, :left_x
  attr_accessor :bottom_y, :middle_y, :top_y
  attr_accessor :close_z, :middle_z, :far_z
  attr_accessor :player_pov_y, :sky_cam_height

  def initialize(schematic)
    self.schematic = schematic

    calculate_schematic_positions
  end

  def camera
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

    optimistic_player_pov_y = PLAYER_POV_HEIGHT + CAMERA_DELTA

    self.player_pov_y = if optimistic_player_pov_y < @schematic.analysis["Height"]
        optimistic_player_pov_y
      else
        @schematic.analysis["Height"]
      end

    self.sky_cam_height = if @schematic.analysis["Height"] < MIN_SKY_POV
        MIN_SKY_POV
      else
        @schematic.analysis["Height"]
      end * 0.65
  end

  # http://stackoverflow.com/questions/18184848/calculate-pitch-and-yaw-between-two-unknown-points
  def pitch(point1, point2)
    dX = point1[:x] - point2[:x]
    dY = point1[:y] - point2[:y]
    dZ = point1[:z] - point2[:z]

    Math.atan2(Math.sqrt(dZ * dZ + dX * dX), dY) + Math::PI
  end

  def yaw(point1, point2)
    dX = point1[:x] - point2[:x]
    dY = point1[:y] - point2[:y]
    dZ = point1[:z] - point2[:z]

    Math.atan2(dZ, dX)
  end

end
