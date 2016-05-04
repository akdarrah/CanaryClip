class CameraAngle
  attr_accessor :schematic

  def initialize(schematic)
    self.schematic = schematic
  end

  def camera_and_focus_coordinates
    raise NotImplementedError
  end
end
