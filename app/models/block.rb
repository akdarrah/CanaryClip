class Block < ActiveRecord::Base
  INVISIBLE_MINECRAFT_IDS = [0, 95]

  has_many :block_counts, dependent: :destroy
  has_many :schematics, through: :block_counts

  validates :minecraft_id, :permalink, presence: true
  validates :minecraft_id, :permalink, uniqueness: true

  has_attached_file :icon
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/

  before_validation :set_permalink

  def to_param
    permalink
  end

  private

  def set_permalink
    self.permalink = display_name.parameterize
  end
end
