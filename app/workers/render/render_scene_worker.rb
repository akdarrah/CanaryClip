class Render::RenderSceneWorker
  include Sidekiq::Worker

  TEMPLATE_WORLD_PATH = Rails.root + "private/Blank188"
  MCE_PY_PATH         = "/Users/user/Developer/minebuild/pymclevel/mce.py"
  DEST_COORDINATES    = "#{SceneDirector::PASTE_X}, #{SceneDirector::PASTE_Y}, #{SceneDirector::PASTE_Z}"

  TEMPLATE_SCENE_PATH  = Rails.root + "private/scene"
  CHUNKY_LAUNCHER_PATH = "/Users/user/Desktop/ChunkyLauncher.jar"
  CONFIG_FILE_NAME     = "Blank188.json"
  IMAGE_FILE_NAME      = "Blank188-30.png"

  def perform(render_id)
    @render         = Render.find(render_id)
    @schematic      = @render.schematic
    @tmp_world_path = Rails.root + "tmp/worlds/#{@render.id}"

    @render.render!
    create_world!

    @render.file = rendered_image_file
    @render.complete!

    # TODO: Cleanup tmp files & Transaction for errors
  end

  private #####################################################################

  # TODO: Each Render needs a tmp world
  def create_world!
    FileUtils.cp_r TEMPLATE_WORLD_PATH, @tmp_world_path
    system "python #{MCE_PY_PATH} #{@tmp_world_path} import #{@schematic.file.path} #{DEST_COORDINATES}"
  end

  def rendered_image_file
    tmp_scene_path = Rails.root + "tmp/scenes/#{@render.id}"

    FileUtils.cp_r TEMPLATE_SCENE_PATH, tmp_scene_path

    camera_angle   = "CameraAngles::#{@render.camera_angle.camelize}".constantize
    config_path    = tmp_scene_path + CONFIG_FILE_NAME
    image_path     = tmp_scene_path + IMAGE_FILE_NAME
    template_json  = JSON.parse(File.read(config_path))
    scene_director = SceneDirector.new(@schematic, @tmp_world_path, template_json, camera_angle)

    File.open(config_path, "w"){|f| f.write(scene_director.to_json)}
    system "java -jar #{CHUNKY_LAUNCHER_PATH} -scene-dir #{tmp_scene_path} -render Blank188"

    File.open(image_path)
  end
end
