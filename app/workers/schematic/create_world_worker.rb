class Schematic::CreateWorldWorker
  include Sidekiq::Worker

  TEMPLATE_WORLD_PATH = Rails.root + "private/Blank188"
  MCE_PY_PATH         = "/Users/user/Developer/minebuild/pymclevel/mce.py"
  DEST_COORDINATES    = "#{SceneDirector::PASTE_X}, #{SceneDirector::PASTE_Y}, #{SceneDirector::PASTE_Z}"

  def perform(schematic_id)
    @schematic = Schematic.find schematic_id

    FileUtils.cp_r TEMPLATE_WORLD_PATH, @schematic.tmp_world_path
    system "python #{MCE_PY_PATH} #{@schematic.tmp_world_path} import #{@schematic.file.path} #{DEST_COORDINATES}"
    @schematic.world_created!
  end
end
