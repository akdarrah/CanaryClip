class Render < ActiveRecord::Base
  DEVELOPMENT_SPP = 30
  PRODUCTION_SPP  = 30

  STANDARD_RESOLUTION = '1024x768'
  HIGH_RESOLUTION     = '1920x1080'

  RESOLUTIONS = {
    STANDARD_RESOLUTION => {width: 1024, height: 768},
    HIGH_RESOLUTION     => {width: 1920, height: 1080}
  }

  belongs_to :schematic
  belongs_to :texture_pack

  validates :schematic, :resolution, :camera_angle, :samples_per_pixel, :texture_pack, presence: true
  validates :samples_per_pixel, numericality: { only_integer: true }

  acts_as_list scope: [:schematic, :resolution]

  validates :camera_angle, inclusion: {in: CameraAngle::AVAILABLE}
  validates :resolution, inclusion: {in: RESOLUTIONS.keys}

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  validates :camera_angle, uniqueness: {scope: [:schematic_id, :resolution]}

  before_validation :set_samples_per_pixel
  before_validation :set_resolution

  scope :standard_resolution, -> { where(resolution: STANDARD_RESOLUTION) }
  scope :high_resolution, -> { where(resolution: HIGH_RESOLUTION) }

  scope :completed, -> { where(state: :completed) }

  state_machine :state, :initial => :pending do
    after_transition :pending => :scheduled,
      :do => :schedule_job
    after_transition :rendering => :completed,
      :do => :publish_schematic

    event :schedule do
      transition :pending => :scheduled
    end

    event :render do
      transition :scheduled => :rendering
    end

    event :complete do
      transition :rendering => :completed
    end
  end

  private #####################################################################

  def primary_render
    camera_angle == CameraAngle::PRIMARY &&
      resolution == STANDARD_RESOLUTION
  end
  alias :primary_render? :primary_render

  def schedule_job
    if primary_render?
      Render::PreferredSceneRendererWorker.perform_async(id)
    else
      Render::SceneRendererWorker.perform_async(id)
    end
  end

  def publish_schematic
    if primary_render?
      schematic.publish!
    end
  end

  def set_samples_per_pixel
    self.samples_per_pixel ||= if Rails.env.production?
        PRODUCTION_SPP
      else
        DEVELOPMENT_SPP
      end
  end

  def set_resolution
    self.resolution ||= STANDARD_RESOLUTION
  end

end
