class Block < ActiveRecord::Base
  validates :minecraft_id, presence: true
  validates :minecraft_id, uniqueness: true

  has_attached_file :icon
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/
end
