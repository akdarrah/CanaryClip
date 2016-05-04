class SceneDirector
  attr_accessor :schematic, :template_config

  PASTE_X = 1159
  PASTE_Y = 4
  PASTE_Z = 744

  CAMERA_DISTANCE   = 10
  CAMERA_VIEW_DELTA = 5
  CAMERA_Y          = 6

  def initialize(schematic, template_config)
    self.schematic       = schematic
    self.template_config = template_config

    set_world_path!
    set_camera_position_and_orientation!
  end

  def to_json
    template_config.to_json
  end

  private

  def set_world_path!
    template_config["world"]["path"] = @schematic.tmp_world_path.to_s
  end

  def set_camera_position_and_orientation!
    camera_angles     = CameraAngles::PlayerFront.new(@schematic).camera_and_focus_coordinates
    camera_coordinate = camera_angles[:camera_coordinate]
    focus_coordinate  = camera_angles[:focus_coordinate]
    pitch_and_yaw     = camera_pitch_and_yaw(focus_coordinate, camera_coordinate)

    template_config['camera']['position']['x']        = camera_coordinate[:x]
    template_config['camera']['position']['y']        = camera_coordinate[:y]
    template_config['camera']['position']['z']        = camera_coordinate[:z]
    template_config['camera']['orientation']['pitch'] = pitch_and_yaw[:pitch]
    template_config['camera']['orientation']['yaw']   = pitch_and_yaw[:yaw]
  end

  # http://stackoverflow.com/questions/18184848/calculate-pitch-and-yaw-between-two-unknown-points
  def camera_pitch_and_yaw(block_coordinate, camera_coordinate)
    dX = block_coordinate[:x] - camera_coordinate[:x]
    dY = block_coordinate[:y] - camera_coordinate[:y]
    dZ = block_coordinate[:z] - camera_coordinate[:z]

    {
      yaw:   Math.atan2(dZ, dX),
      pitch: Math.atan2(Math.sqrt(dZ * dZ + dX * dX), dY) + Math::PI
    }
  end
end
