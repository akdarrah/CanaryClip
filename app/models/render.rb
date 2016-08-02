class Render < ActiveRecord::Base
  belongs_to :schematic
  validates :schematic, :camera_angle, :samples_per_pixel, presence: true
  validates :samples_per_pixel, numericality: { only_integer: true }

  validates :camera_angle, inclusion: {in: CameraAngle::AVAILABLE}

  has_attached_file :file
  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  validates :camera_angle, uniqueness: {scope: :schematic_id}

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

end
