class SceneDirector
  attr_accessor :schematic, :template_config

  PASTE_X = 1159
  PASTE_Y = 4
  PASTE_Z = 744

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
    camera = CameraAngles::SkyRight.new(@schematic).camera

    template_config['camera']['position']['x']        = camera[:x]
    template_config['camera']['position']['y']        = camera[:y]
    template_config['camera']['position']['z']        = camera[:z]
    template_config['camera']['orientation']['pitch'] = camera[:pitch]
    template_config['camera']['orientation']['yaw']   = camera[:yaw]
  end
end
