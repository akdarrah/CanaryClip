class Schematic::CollectMetadataWorker
  include Sidekiq::Worker

  def perform(schematic_id)
    @schematic = Schematic.find schematic_id

    @schematic.parsed_nbt_data = JSON.parse(`nbtv #{@schematic.escaped_file_path}`)

    @schematic.width  = @schematic.parsed_nbt_data["Schematic"]["Width"]
    @schematic.length = @schematic.parsed_nbt_data["Schematic"]["Length"]
    @schematic.height = @schematic.parsed_nbt_data["Schematic"]["Height"]
    @schematic.save!

    grouped_blocks = @schematic.parsed_nbt_data['Schematic']['Blocks'].group_by{|i| i}
    grouped_blocks.each do |minecraft_id, blocks|
      # TODO: What does a negative minecraft_id mean?
      if minecraft_id >= 0
        BlockCount.create!(
          :block     => Block.find_by_minecraft_id!(minecraft_id),
          :schematic => @schematic,
          :count     => blocks.count
        )
      end
    end

    @schematic.create_world!
  end
end
