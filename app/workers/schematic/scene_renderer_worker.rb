class Schematic::SceneRendererWorker
  include Sidekiq::Worker

  TEMPLATE_SCENE_PATH  = Rails.root + "private/scene"
  CHUNKY_LAUNCHER_PATH = "/Users/user/Desktop/ChunkyLauncher.jar"
  CONFIG_FILE_NAME     = "Blank188.json"
  IMAGE_FILE_NAME      = "Blank188-30.png"

  def perform(schematic_id, camera_angle_sym)
    @schematic     = Schematic.find schematic_id
    tmp_scene_path = Rails.root + "tmp/scenes/#{@schematic.id}"

    FileUtils.cp_r TEMPLATE_SCENE_PATH, tmp_scene_path

    camera_angle   = "CameraAngles::#{camera_angle_sym.camelize}".constantize
    config_path    = tmp_scene_path + CONFIG_FILE_NAME
    image_path     = tmp_scene_path + IMAGE_FILE_NAME
    template_json  = JSON.parse(File.read(config_path))
    scene_director = SceneDirector.new(@schematic, template_json, camera_angle)

    File.open(config_path, "w"){|f| f.write(scene_director.to_json)}
    system "java -jar #{CHUNKY_LAUNCHER_PATH} -scene-dir #{tmp_scene_path} -render Blank188"

    Render.create!({
      :schematic         => @schematic,
      :samples_per_pixel => scene_director.samples_per_pixel,
      :camera_angle      => camera_angle_sym,
      :file              => File.open(image_path)
    })
  ensure
    FileUtils.rm_r tmp_scene_path
  end
end
