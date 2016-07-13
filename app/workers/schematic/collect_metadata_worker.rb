class Schematic::CollectMetadataWorker
  include Sidekiq::Worker

  def perform(schematic_id)
    @schematic = Schematic.find schematic_id

    @schematic.width  = @schematic.nbt_file["Width"]
    @schematic.length = @schematic.nbt_file["Length"]
    @schematic.height = @schematic.nbt_file["Height"]
    @schematic.save!

    @schematic.create_world!
  end
end
