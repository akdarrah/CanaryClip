class Image < ActiveRecord::Base
  belongs_to :schematic
  validates :schematic, presence: true

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
  validates :file, attachment_presence: true
end
