class Render < ActiveRecord::Base
  DEVELOPMENT_SPP = 30
  PRODUCTION_SPP  = 100

  belongs_to :schematic
  validates :schematic, :camera_angle, :samples_per_pixel, presence: true
  validates :samples_per_pixel, numericality: { only_integer: true }

  validates :camera_angle, inclusion: {in: CameraAngle::AVAILABLE}

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  validates :camera_angle, uniqueness: {scope: :schematic_id}

  before_validation :set_samples_per_pixel

  scope :camera_angle_order, (lambda do
    order(CameraAngle::AVAILABLE.map{|angle| "renders.camera_angle = '#{angle}' DESC"}.join(', '))
  end)

  state_machine :state, :initial => :pending do
    after_transition :pending => :scheduled,
      :do => :schedule_job

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

  def schedule_job
    Render::RenderSceneWorker.perform_async(id)
  end

  def set_samples_per_pixel
    self.samples_per_pixel ||= if Rails.env.production?
        PRODUCTION_SPP
      else
        DEVELOPMENT_SPP
      end
  end

end
