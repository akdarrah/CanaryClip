class Schematic::CollectMetadataWorker
  include Sidekiq::Worker

  def perform(schematic_id)
    @schematic = Schematic.find schematic_id

    @schematic.parsed_nbt_data = JSON.parse(`nbtv #{@schematic.escaped_file_path}`)

    @schematic.width  = @schematic.parsed_nbt_data["Schematic"]["Width"]
    @schematic.length = @schematic.parsed_nbt_data["Schematic"]["Length"]
    @schematic.height = @schematic.parsed_nbt_data["Schematic"]["Height"]
    @schematic.save!

    @schematic.create_world!
  end
end
