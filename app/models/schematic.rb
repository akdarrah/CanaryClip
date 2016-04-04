class Schematic < ActiveRecord::Base
  belongs_to :profile

  has_attached_file :file

  validates_attachment :file,
    :presence     => true,
    :content_type => { content_type: "application/schematic" },
    :size         => { in: 0..10.megabytes }

  validates :name, :profile, presence: true
  validates :permalink, uniqueness: true, allow_blank: true

  after_create :set_permalink

  def to_param
    permalink
  end

  private

  # This has to be in an after_create since we need
  # an id to generate the hashid
  def set_permalink
    update_column :permalink, HASHIDS.encode(id)
  end

end
