class Favorite < ActiveRecord::Base
  belongs_to :character
  belongs_to :schematic

  validates :character, :schematic, presence: true
  validates :character, uniqueness: {scope: :schematic_id}

  def self.for_character(character)
    if character.present?
      where(character: character).first
    end
  end
end
