class Schematic < ActiveRecord::Base
  belongs_to :profile

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
  after_save :delete_temporary_file
  after_create :set_permalink

  def analysis
    data = NBTFile.load(File.read(file.path)).last
    data.slice("Width", "Length", "Height")
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

  private

  def sync_name_to_file
    self.file_file_name = "#{name}.schematic"
  end

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

end
