class Character < ActiveRecord::Base
  belongs_to :user

  has_many :schematics, dependent: :destroy

  has_many :tracked_downloads, dependent: :destroy
  has_many :downloaded_schematics, through: :tracked_downloads, source: :schematic

  validates :uuid, :username, uniqueness: true, allow_blank: true
  validate :username_or_uuid_required

  has_attached_file :avatar,
    :default_url => "/assets/default_avatar.png"
  validates_attachment :avatar,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  after_commit :schedule_api_worker, on: :create

  def to_s
    (username || uuid)
  end
  alias :username_or_uuid :to_s

  private

  def schedule_api_worker
    CharacterApiWorker.perform_async(id)
  end

  def username_or_uuid_required
    if username_or_uuid.blank?
      errors.add(:base, 'Username or UUID required')
    end
  end
end
