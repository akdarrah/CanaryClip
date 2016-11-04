class SceneRenderer
  TEMPLATE_WORLD_PATH = Rails.root + "private/Blank188"
  MCE_PY_PATH         = Rails.root + "private/pymclevel/mce.py"

  TEMPLATE_SCENE_PATH  = Rails.root + "private/scene"
  CHUNKY_LAUNCHER_PATH = Rails.root + "private/ChunkyLauncher.jar"
  CONFIG_FILE_NAME     = "Blank188.json"

  attr_accessor :render, :schematic, :tmp_world_path,
    :tmp_scene_path, :texture_pack_path

  def initialize(render)
    if !File.exists?(MCE_PY_PATH)
      raise "Pymclevel must be installed to #{MCE_PY_PATH}"
    end

    self.render            = render
    self.schematic         = render.schematic
    self.tmp_world_path    = Rails.root + "tmp/worlds/#{render.id}"
    self.tmp_scene_path    = Rails.root + "tmp/scenes/#{render.id}"
    self.texture_pack_path = render.texture_pack.zip_file.path
  end

  def render!
    ActiveRecord::Base.transaction do
      render.render!
      create_world!

      render.file = rendered_image_file
      render.complete!
    end
  ensure
    FileUtils.rm_r tmp_world_path if File.exists?(tmp_world_path.to_s)
    FileUtils.rm_r tmp_scene_path if File.exists?(tmp_scene_path.to_s)
  end

  private #####################################################################

  def create_world!
    FileUtils.cp_r TEMPLATE_WORLD_PATH, tmp_world_path
    system "python #{MCE_PY_PATH} #{tmp_world_path} import #{schematic.file.path} #{schematic.paste_coordinates}"
  end

  def rendered_image_file
    FileUtils.cp_r TEMPLATE_SCENE_PATH, tmp_scene_path

    camera_angle   = "CameraAngles::#{render.camera_angle.camelize}".constantize
    config_path    = tmp_scene_path + CONFIG_FILE_NAME
    image_path     = tmp_scene_path + "Blank188-#{render.samples_per_pixel}.png"
    template_json  = JSON.parse(File.read(config_path))
    scene_director = SceneDirector.new(render, tmp_world_path, template_json, camera_angle)

    File.open(config_path, "w"){|f| f.write(scene_director.to_json)}
    system "java -jar #{CHUNKY_LAUNCHER_PATH} -texture #{texture_pack_path} -scene-dir #{tmp_scene_path} -render Blank188"

    File.open(image_path)
  end

end
