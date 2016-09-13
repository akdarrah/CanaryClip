class Server < ActiveRecord::Base
  belongs_to :owner_user, class_name: "User"
  belongs_to :owner_character, class_name: "Character"

  validates_presence_of :name, :permalink,
    :owner_user, :authenticity_token, :hostname

  validates :name, :permalink, uniqueness: true

  validate :owner_character_must_belong_to_owner_user,
    if: Proc.new { |s| s.owner_character.present? }

  # TODO: Hostname should be domain name or IP

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

  def owner_character_must_belong_to_owner_user
    if !owner_user.characters.where(id: owner_character_id).exists?
      errors.add(:owner_character, :must_belong_to_user)
    end
  end

end
