class Character < ActiveRecord::Base
  belongs_to :user

  has_many :schematics, dependent: :destroy

  has_many :tracked_downloads, dependent: :destroy
  has_many :downloaded_schematics, through: :tracked_downloads, source: :schematic
  has_many :character_claims
  has_many :favorites, dependent: :destroy

  validates :uuid, :username, :permalink, uniqueness: true, allow_blank: true
  validates :permalink, :username, presence: true

  has_attached_file :avatar,
    :default_url => "/assets/default_avatar.png"
  validates_attachment :avatar,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  before_validation :set_permalink
  after_commit :schedule_api_worker, on: :create

  def to_s
    username
  end

  def to_param
    permalink
  end

  private

  def schedule_api_worker
    CharacterApiWorker.perform_async(id)
  end

  def set_permalink
    if username.present?
      self.permalink = username.parameterize
    end
  end
end
