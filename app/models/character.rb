class Character < ActiveRecord::Base
  has_many :schematics

  validates :uuid, presence: true
  validates :uuid, uniqueness: true

  has_attached_file :avatar
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  after_create :schedule_api_worker

  private

  def schedule_api_worker
    CharacterApiWorker.perform_async(id)
  end
end
