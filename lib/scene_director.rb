class SceneDirector
  attr_accessor :render, :schematic, :template_config,
    :camera_angle, :tmp_world_path

  PASTE_X = 1159
  PASTE_Y = 4
  PASTE_Z = 744

  def initialize(render, tmp_world_path, template_config, camera_angle)
    self.render          = render
    self.schematic       = render.schematic
    self.tmp_world_path  = tmp_world_path
    self.template_config = template_config
    self.camera_angle    = camera_angle

    set_world_path!
    set_target_samples_per_pixel!
    set_resolution!
    set_camera_position_and_orientation!
  end

  def to_json
    template_config.to_json
  end

  private

  def set_world_path!
    template_config["world"]["path"] = @tmp_world_path.to_s
  end

  def set_target_samples_per_pixel!
    template_config["sppTarget"] = render.samples_per_pixel
  end

  def set_resolution!
    resolution = Render::RESOLUTIONS[@render.resolution]

    template_config['width']  = resolution[:width]
    template_config['height'] = resolution[:height]
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
