class Schematic < ActiveRecord::Base
  belongs_to :profile
  has_many :renders, dependent: :destroy

  has_attached_file :file

  validates_attachment :file,
    :presence     => true,
    :size         => { in: 0..10.megabytes }

  # TODO: Why do we have to disable in initializers/paperclip.rb?
  validates_attachment_content_type :file, content_type: ['application/x-gzip', 'application/gzip']
  validates_attachment_file_name :file, :matches => [/schematic\Z/]

  # validates :name, :profile, presence: true
  validates :name, presence: true
  validates :permalink, uniqueness: true, allow_blank: true

  attr_accessor :temporary_file

  before_create :sync_name_to_file
  after_create :delete_temporary_file
  after_create :set_permalink

  state_machine :state, :initial => :new do
    before_transition :new => :creating_world, :do => :schedule_world_creation
    before_transition :creating_world => :rendering, :do => :schedule_scene_renderings

    event :create_world do
      transition :new => :creating_world
    end

    event :schedule_renders do
      transition :creating_world => :rendering
    end

    event :publish do
      transition :rendering => :published
    end
  end

  def analysis
    @analysis ||= NBTFile.load(File.read(file.path)).last
    @analysis.slice("Width", "Length", "Height")
  end

  def to_param
    permalink
  end

  def raw_schematic_data=(data)
    filepath = "#{Rails.root}/tmp/schematics/#{object_id}-#{Time.now.to_i}.schematic"

    File.open(filepath, "w"){|file| file.write(data)}
    File.open(filepath, "r"){|file| self.file = file}

    self.temporary_file = filepath
  end

  def tmp_world_path
    Rails.root + "tmp/worlds/#{id}"
  end

  private

  def sync_name_to_file
    self.file_file_name = "#{name}.schematic"
  end

  def delete_temporary_file
    if temporary_file.present?
      File.delete temporary_file
    end
  end

  def delete_tmp_world
    FileUtils.rm_r tmp_world_path
  end

  # This has to be in an after_create since we need
  # an id to generate the hashid
  def set_permalink
    update_column :permalink, HASHIDS.encode(id)
  end

  def schedule_world_creation
    Schematic::CreateWorldWorker.perform_async(id)
  end

  def schedule_scene_renderings
    CameraAngle::AVAILABLE.each do |camera_angle|
      Schematic::SceneRendererWorker.perform_async(id, camera_angle)
    end
  end

end
