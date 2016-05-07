class SceneDirector
  attr_accessor :schematic, :template_config,
    :samples_per_pixel, :camera_angle

  PASTE_X = 1159
  PASTE_Y = 4
  PASTE_Z = 744

  DEVELOPMENT_SPP = 30
  PRODUCTION_SPP  = 100

  def initialize(schematic, template_config, camera_angle)
    self.schematic       = schematic
    self.template_config = template_config
    self.camera_angle    = camera_angle

    set_world_path!
    set_target_samples_per_pixel!
    set_camera_position_and_orientation!
  end

  def to_json
    template_config.to_json
  end

  private

  def set_world_path!
    template_config["world"]["path"] = @schematic.tmp_world_path.to_s
  end

  def set_target_samples_per_pixel!
    self.samples_per_pixel = if Rails.env.production?
        PRODUCTION_SPP
      else
        DEVELOPMENT_SPP
      end

    template_config["sppTarget"] = samples_per_pixel
  end

  def set_camera_position_and_orientation!
    camera = camera_angle.new(@schematic).camera

    template_config['camera']['position']['x']        = camera[:x]
    template_config['camera']['position']['y']        = camera[:y]
    template_config['camera']['position']['z']        = camera[:z]
    template_config['camera']['orientation']['pitch'] = camera[:pitch]
    template_config['camera']['orientation']['yaw']   = camera[:yaw]
  end
end
