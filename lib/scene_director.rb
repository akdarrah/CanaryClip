class SceneDirector
  attr_accessor :schematic, :template_config

  def initialize(schematic, template_config)
    self.schematic       = schematic
    self.template_config = template_config

    set_world_path!
  end

  def to_json
    template_config.to_json
  end

  private

  def set_world_path!
    template_config["world"]["path"] = @schematic.tmp_world_path.to_s
  end

  # http://stackoverflow.com/questions/18184848/calculate-pitch-and-yaw-between-two-unknown-points
  def camera_pitch_and_yaw(block_coordinate, camera_coordinate)
    dX = block_coordinate[:x] - camera_coordinate[:x]
    dY = block_coordinate[:y] - camera_coordinate[:y]
    dZ = block_coordinate[:z] - camera_coordinate[:z]

    {
      yaw:   Math.atan2(dZ, dX),
      pitch: Math.atan2(Math.sqrt(dZ * dZ + dX * dX), dY) + Math::PI
    }
  end
end
