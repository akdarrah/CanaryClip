class Schematic < ActiveRecord::Base
  is_impressionable

  serialize :parsed_nbt_data, JSON

  belongs_to :character

  has_many :block_counts, dependent: :destroy
  has_many :blocks, through: :block_counts

  has_many :tracked_downloads, dependent: :destroy
  has_many :downloaded_by_characters, through: :tracked_downloads, source: :character

  has_many :renders, dependent: :destroy
  has_one :primary_render,
    -> { standard_resolution.where(camera_angle: CameraAngle::PRIMARY) },
    class_name: "Render"

  has_attached_file :file

  validates_attachment :file,
    :presence     => true,
    :size         => { in: 0..10.megabytes }

  # TODO: Why do we have to disable in initializers/paperclip.rb?
  validates_attachment_content_type :file, content_type: ['application/x-gzip', 'application/gzip']
  validates_attachment_file_name :file, :matches => [/schematic\Z/]

  validates :character, presence: true
  validates :permalink, uniqueness: true, allow_blank: true

  validates :width, :length, :height,
    numericality: {greater_than_or_equal_to: 0, only_integer: true},
    allow_blank: true

  scope :published, -> { where(state: :published) }
  scope :chronological, -> { order(:created_at) }

  attr_accessor :temporary_file

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

  def to_param
    permalink
  end

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

  def delete_temporary_file
    if temporary_file.present?
      File.delete temporary_file
    end
  end

  # This has to be in an after_create since we need
  # an id to generate the hashid
  def set_permalink
    update_column :permalink, HASHIDS.encode(id)
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
        :camera_angle => camera_angle
      )
    end

    renders.each(&:schedule!)
  end

end
