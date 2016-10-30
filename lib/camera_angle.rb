class CameraAngle
  # TODO: It would be cool if we could calculate this to
  # optimize the amount of the schematic that is visible.
  CAMERA_DISTANCE_FROM_SCHEMATIC = 15

  # 70 is fov angle (in degrees) from chunky
  FOV_RADIAN = (70 * Math::PI / 180)

  CAPTURE_PERCENTAGE = 0.85

  PRIMARY   = 'full_front'
  SECONDARY = [
    'full_left', 'full_right', 'full_back'
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
  attr_accessor :width_or_height_distance, :length_or_height_distance, :width_or_length_distance

  def initialize(schematic)
    self.schematic = schematic

    calculate_schematic_positions
  end

  def camera
    raise NotImplementedError
  end

  private

  def calculate_schematic_positions
    self.right_x  = @schematic.paste_x
    self.middle_x = @schematic.paste_x + (@schematic.width / 2)
    self.left_x   = @schematic.paste_x + @schematic.width

    self.bottom_y = @schematic.paste_y
    self.middle_y = @schematic.paste_y + (@schematic.height / 2)
    self.top_y    = @schematic.paste_y + @schematic.height

    self.close_z  = @schematic.paste_z
    self.middle_z = @schematic.paste_z + (@schematic.length / 2)
    self.far_z    = @schematic.paste_z + @schematic.length

    optimistic_player_pov_y = PLAYER_POV_HEIGHT + CAMERA_DELTA

    self.player_pov_y = if optimistic_player_pov_y < @schematic.height
        optimistic_player_pov_y
      else
        @schematic.height
      end

    self.sky_cam_height = if @schematic.height < MIN_SKY_POV
        MIN_SKY_POV
      else
        @schematic.height
      end * 0.65

    width_or_height = ([@schematic.height, @schematic.width].max * CAPTURE_PERCENTAGE)
    self.width_or_height_distance = (width_or_height / 2) / Math::tan(FOV_RADIAN / 2)

    length_or_height = ([@schematic.height, @schematic.length].max * CAPTURE_PERCENTAGE)
    self.length_or_height_distance = (length_or_height / 2) / Math::tan(FOV_RADIAN / 2)

    width_or_length = ([@schematic.width, @schematic.length].max * CAPTURE_PERCENTAGE)
    self.width_or_length_distance = (width_or_length / 2) / Math::tan(FOV_RADIAN / 2)
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
