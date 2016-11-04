class TexturePack < ActiveRecord::Base
  has_many :schematics
  has_many :renders

  validates :name, :permalink, presence: true
  validates :name, :permalink, uniqueness: true

  has_attached_file :zip_file

  validates_attachment :zip_file,
    :presence     => true,
    :size         => { in: 0..10.megabytes }
  validates_attachment_content_type :zip_file,
    content_type: ['application/zip']

  before_validation :set_permalink

  def self.default
    where(default: true).first
  end

  private

  def set_permalink
    self.permalink = name.parameterize
  end
end
