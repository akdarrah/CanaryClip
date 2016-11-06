class Schematic < ActiveRecord::Base
  self.per_page = 15

  is_impressionable
  acts_as_taggable

  serialize :parsed_nbt_data, JSON

  belongs_to :character
  belongs_to :server
  belongs_to :texture_pack
  belongs_to :user

  has_many :block_counts, dependent: :destroy
  has_many :blocks, through: :block_counts

  has_many :favorites, dependent: :destroy
  has_many :favorited_by_characters, through: :favorites, source: :character

  has_many :tracked_downloads, dependent: :destroy
  has_many :downloaded_by_characters, through: :tracked_downloads, source: :character

  has_many :renders, -> { order(position: :asc) }, dependent: :destroy

  # Initially, this will be Standard Resolution with CameraAngle::PRIMARY
  # But users can change this by re-ordering
  has_one :primary_render,
    -> { where(position: 1) },
    class_name: "Render"

  accepts_nested_attributes_for :renders

  has_attached_file :file

  validates_attachment :file,
    :presence     => true,
    :size         => { in: 0..10.megabytes }

  # TODO: Why do we have to disable in initializers/paperclip.rb?
  validates_attachment_content_type :file, content_type: ['application/x-gzip', 'application/gzip', 'application/octet-stream']
  validates_attachment_file_name :file, :matches => [/schematic\Z/]

  validates :texture_pack, presence: true
  validates :permalink, uniqueness: true, allow_blank: true
  validate :character_or_user_required

  validates :width, :length, :height,
    numericality: {greater_than_or_equal_to: 0, only_integer: true},
    allow_blank: true

  scope :published, -> { where(state: :published) }
  scope :chronological, -> { order(:created_at) }

  attr_accessor :temporary_file

  before_validation :set_default_texture_pack
  before_validation :set_user_from_character
  before_destroy :verify_destroyable
  after_create :delete_temporary_file
  after_create :set_permalink
  after_create :sync_permalink_to_file

  state_machine :state, :initial => :new do
    after_transition :new => :collecting_metadata,
      :do => :schedule_metadata_collection
    after_transition :collecting_metadata => :rendering,
      :do => :create_renders

    event :collect_metadata do
      transition :new => :collecting_metadata
    end

    event :render do
      transition :collecting_metadata => :rendering
    end

    event :publish do
      transition :rendering => :published
    end
  end

  def destroyable
    published?
  end
  alias :destroyable? :destroyable

  # Sanitize?
  def pipelined_description
    SocialPipeline.call(description.to_s)[:output].to_s
  end

  def admin_access?(user)
    user.schematics.where(id: self).exists?
  end

  def to_param
    permalink
  end

  def region_paster
    @region_paster ||= RegionPaster.new(self)
  end
  delegate :paste_x, :paste_y, :paste_z, :paste_coordinates, to: :region_paster

  # Keep inspect sane by omitting parsed_nbt_data
  def inspect
    inspection = if @attributes
      self.class.column_names.collect { |name|
        if has_attribute?(name)
          if name == 'parsed_nbt_data'
            "#{name}: ..."
          else
            "#{name}: #{attribute_for_inspect(name)}"
          end
        end
      }.compact.join(", ")
    else
      "not initialized"
    end

    "#<#{self.class} #{inspection}>"
  end

  def escaped_file_path
    Shellwords.escape file.path
  end

  def raw_schematic_data=(data)
    filepath = "#{Rails.root}/tmp/schematics/#{object_id}-#{Time.now.to_i}.schematic"

    File.open(filepath, "w"){|file| file.write(data)}
    File.open(filepath, "r"){|file| self.file = file}

    self.temporary_file = filepath
  end

  def total_block_count
    block_counts.visible.sum(:count)
  end

  def total_show_impressions
    impressions.where(action_name: 'show').count
  end

  def total_download_impressions
    impressions.where(action_name: 'download').count
  end

  private

  def character_or_user_required
    if character.blank? && user.blank?
      errors.add(:base, "Character or user must be present")
    end
  end

  def set_default_texture_pack
    self.texture_pack ||= TexturePack.default
  end

  def set_user_from_character
    self.user ||= character.try(:user)
  end

  def verify_destroyable
    if !destroyable
      errors.add(:base, "cannot be destroyed")
      return false
    end
  end

  def delete_temporary_file
    if temporary_file.present?
      File.delete temporary_file
    end
  end

  # This has to be in an after_create since we need
  # an id to generate the hashid
  def set_permalink
    update_column :permalink, SCHEMATIC_HASHIDS.encode(id)
  end

  def sync_permalink_to_file
    update_column :file_file_name, "#{permalink}.schematic"
  end

  def schedule_metadata_collection
    Schematic::CollectMetadataWorker.perform_async(id)
  end

  def create_renders
    CameraAngle::AVAILABLE.each do |camera_angle|
      renders.create!(
        :schematic    => self,
        :camera_angle => camera_angle,
        :texture_pack => texture_pack
      )
    end

    renders.each(&:schedule!)
  end

end
