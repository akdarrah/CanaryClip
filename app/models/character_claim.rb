class CharacterClaim < ActiveRecord::Base
  belongs_to :character
  belongs_to :user

  validates :user, :character_username, :state, presence: true

  before_create :find_or_create_character
  after_create :set_token

  state_machine :state, :initial => :pending do
    after_transition :pending => :claimed,
      :do => :assign_character_to_user

    event :claim do
      transition :pending => :claimed
    end

    event :expire do
      transition :pending => :expired
    end
  end

  def to_param
    token
  end

  private

  def find_or_create_character
    self.character = Character.find_or_create_by!(username: character_username)
  end

  def set_token
    update_column :token, CHARACTER_CLAIM_HASHIDS.encode(id)
  end

  def assign_character_to_user
    user.characters << character
  end
end
