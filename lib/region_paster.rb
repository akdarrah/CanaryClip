class RegionPaster
  UnknownDimensionsError = Class.new(RuntimeError)

  REGION_MIN_X = 1024
  REGION_MAX_X = 1535

  REGION_MIN_Z = 512
  REGION_MAX_Z = 1023

  # Ground level
  PASTE_Y = 4

  attr_accessor :schematic, :paste_x, :paste_y, :paste_z

  def initialize(schematic)
    self.schematic = schematic

    if schematic.parsed_nbt_data.blank?
      raise UnknownDimensionsError
    end

    calculate_paste_coordinates!
  end

  def to_s
    "#{paste_x}, #{paste_y}, #{paste_z}"
  end
  alias :paste_coordinates :to_s

  # http://imgur.com/a/4qnLI
  # https://dinnerbone.com/minecraft/tools/coordinates/
  def calculate_paste_coordinates!
    self.paste_x = (middle_x - half_schematic_width)
    self.paste_y = PASTE_Y
    self.paste_z = (middle_z - half_schematic_length)
  end

  private

  def x_space
    REGION_MAX_X - REGION_MIN_X
  end

  def middle_x
    REGION_MIN_X + (x_space / 2)
  end

  def half_schematic_width
    (schematic.width / 2)
  end

  def z_space
    REGION_MAX_Z - REGION_MIN_Z
  end

  def middle_z
    REGION_MIN_Z + (z_space / 2)
  end

  def half_schematic_length
    (schematic.length / 2)
  end

end
