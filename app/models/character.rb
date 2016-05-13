class Character < ActiveRecord::Base
  has_many :schematics, dependent: :destroy

  validates :uuid, presence: true
  validates :uuid, uniqueness: true

  has_attached_file :avatar,
    :default_url => "/assets/default_avatar.png"
  validates_attachment :avatar,
    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }

  after_create :schedule_api_worker

  def to_s
    (username || uuid)
  end

  private

  def schedule_api_worker
    CharacterApiWorker.perform_async(id)
  end
end
