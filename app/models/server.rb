class Server < ActiveRecord::Base
  belongs_to :owner_user, class_name: "User"
  belongs_to :owner_character, class_name: "Character"

  has_many :schematics, dependent: :destroy

  validates_presence_of :name, :permalink,
    :owner_user, :authenticity_token, :hostname

  validates :name, :permalink, uniqueness: true

  validate :hostname_is_dns_hostname_or_ip_address
  validate :owner_character_must_belong_to_owner_user,
    if: Proc.new { |s| s.owner_character.present? }

  before_validation :set_permalink
  before_validation :set_authenticity_token, on: :create

  def self.official
    where(claims_allowed: true).first
  end

  def to_param
    permalink
  end

  def to_s
    name
  end

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

  def hostname_is_dns_hostname_or_ip_address
    any_ipv4 = Regexy::Web::IPv4.new(:normal) |
      Regexy::Web::IPv4.new(:with_port)

    if (hostname =~ any_ipv4).nil? && (hostname =~ Regexy::Web::HostName.new).nil?
      errors.add(:hostname, :invalid)
    end
  end

end
