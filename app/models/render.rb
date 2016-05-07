class Render < ActiveRecord::Base
  belongs_to :schematic
  validates :schematic, :camera_angle, :samples_per_pixel, presence: true
  validates :samples_per_pixel, numericality: { only_integer: true }

  validates :camera_angle, inclusion: {in: CameraAngle::AVAILABLE}

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
  validates :file, attachment_presence: true
end
