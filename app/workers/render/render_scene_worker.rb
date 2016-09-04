class Render::RenderSceneWorker
  include Sidekiq::Worker

  TEXTURE_PATH = Rails.root + "private/Faithful.zip"

  TEMPLATE_WORLD_PATH = Rails.root + "private/Blank188"
  MCE_PY_PATH         = Rails.root + "private/pymclevel/mce.py"
  DEST_COORDINATES    = "#{SceneDirector::PASTE_X}, #{SceneDirector::PASTE_Y}, #{SceneDirector::PASTE_Z}"

  TEMPLATE_SCENE_PATH  = Rails.root + "private/scene"
  CHUNKY_LAUNCHER_PATH = Rails.root + "private/ChunkyLauncher.jar"
  CONFIG_FILE_NAME     = "Blank188.json"

  def perform(render_id)
    # Give the transaction time to finish
    sleep 1

    if !File.exists?(MCE_PY_PATH)
      raise "Pymclevel must be installed to #{MCE_PY_PATH}"
    end

    @render         = Render.find(render_id)
    @schematic      = @render.schematic
    @tmp_world_path = Rails.root + "tmp/worlds/#{@render.id}"
    @tmp_scene_path = Rails.root + "tmp/scenes/#{@render.id}"

    ActiveRecord::Base.transaction do
      @render.render!
      create_world!

      @render.file = rendered_image_file
      @render.complete!
    end
  ensure
    FileUtils.rm_r @tmp_world_path if File.exists?(@tmp_world_path.to_s)
    FileUtils.rm_r @tmp_scene_path if File.exists?(@tmp_scene_path.to_s)
  end

  private #####################################################################

  def create_world!
    FileUtils.cp_r TEMPLATE_WORLD_PATH, @tmp_world_path
    system "python #{MCE_PY_PATH} #{@tmp_world_path} import #{@schematic.file.path} #{DEST_COORDINATES}"
  end

  def rendered_image_file
    FileUtils.cp_r TEMPLATE_SCENE_PATH, @tmp_scene_path

    camera_angle   = "CameraAngles::#{@render.camera_angle.camelize}".constantize
    config_path    = @tmp_scene_path + CONFIG_FILE_NAME
    image_path     = @tmp_scene_path + "Blank188-#{@render.samples_per_pixel}.png"
    template_json  = JSON.parse(File.read(config_path))
    scene_director = SceneDirector.new(@render, @tmp_world_path, template_json, camera_angle)

    File.open(config_path, "w"){|f| f.write(scene_director.to_json)}
    system "java -jar #{CHUNKY_LAUNCHER_PATH} -texture #{TEXTURE_PATH} -scene-dir #{@tmp_scene_path} -render Blank188"

    File.open(image_path)
  end
end
