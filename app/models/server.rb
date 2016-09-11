class Server < ActiveRecord::Base
  attr_encrypted :authenticity_token, key: ATTR_ENCRYPTED_KEY

  belongs_to :owner_user, class_name: "User"
  belongs_to :owner_character, class_name: "Character"

  validates_presence_of :name, :permalink,
    :owner_user, :authenticity_token, :hostname

  validates :name, :permalink, uniqueness: true

  # TODO: Hostname should be domain name or IP
  # TODO: Owner character should belong to owner user

  before_validation :set_permalink
  before_validation :set_authenticity_token, on: :create

  private

  def set_permalink
    if name.present?
      self.permalink = name.parameterize
    end
  end

  def set_authenticity_token
    self.authenticity_token ||= UUID.generate(:compact)
  end

end
