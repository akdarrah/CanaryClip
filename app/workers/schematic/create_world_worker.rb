class Schematic::CreateWorldWorker
  include Sidekiq::Worker

  TEMPLATE_WORLD_PATH = Rails.root + "private/Blank188"
  MCE_PY_PATH         = "/Users/user/Developer/minebuild/pymclevel/mce.py"
  DEST_COORDINATES    = "1159, 4, 744"

  def perform(schematic_id)
    @schematic     = Schematic.find schematic_id
    tmp_world_path = Rails.root + "tmp/worlds/#{@schematic.id}"

    FileUtils.cp_r TEMPLATE_WORLD_PATH, tmp_world_path
    system "python #{MCE_PY_PATH} #{tmp_world_path} import #{@schematic.file.path} #{DEST_COORDINATES}"
  end
end
