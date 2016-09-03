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
  validates :schematic, :resolution, :camera_angle, :samples_per_pixel, presence: true
  validates :samples_per_pixel, numericality: { only_integer: true }

  validates :camera_angle, inclusion: {in: CameraAngle::AVAILABLE}
  validates :resolution, inclusion: {in: RESOLUTIONS.keys}

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  validates :camera_angle, uniqueness: {scope: [:schematic_id, :resolution]}

  before_validation :set_samples_per_pixel
  before_validation :set_resolution

  scope :camera_angle_order, (lambda do
    order(CameraAngle::AVAILABLE.map{|angle| "renders.camera_angle = '#{angle}' DESC"}.join(', '))
  end)

  scope :standard_resolution, -> { where(resolution: STANDARD_RESOLUTION) }
  scope :high_resolution, -> { where(resolution: HIGH_RESOLUTION) }

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

  # If the last jobs finish at the same time, there is a chance that the
  # Schematic won't get properly published
  def schedule_job
    schedule_time = rand(1..10).seconds.from_now
    Render::RenderSceneWorker.perform_at(schedule_time, id)
  end

  def publish_schematic
    if !schematic.renders.where.not(state: :completed).exists?
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
