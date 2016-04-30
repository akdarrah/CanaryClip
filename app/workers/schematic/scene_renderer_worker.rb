class Schematic::SceneRendererWorker
  include Sidekiq::Worker

  TEMPLATE_SCENE_PATH  = Rails.root + "private/scene"
  CHUNKY_LAUNCHER_PATH = "/Users/user/Desktop/ChunkyLauncher.jar"
  CONFIG_FILE_NAME     = "Blank188.json"

  def perform(schematic_id)
    @schematic     = Schematic.find schematic_id
    tmp_scene_path = Rails.root + "tmp/scenes/#{@schematic.id}"
    tmp_world_path = Rails.root + "tmp/worlds/#{@schematic.id}"

    FileUtils.cp_r TEMPLATE_SCENE_PATH, tmp_scene_path

    config_path  = tmp_scene_path + CONFIG_FILE_NAME
    scene_config = JSON.parse(File.read(config_path))
    scene_config["world"]["path"] = tmp_world_path.to_s
    File.open(config_path, "w") do |f|
      f.write(scene_config.to_json)
    end

    system "java -jar #{CHUNKY_LAUNCHER_PATH} -scene-dir #{tmp_scene_path} -render Blank188"
  end
end
