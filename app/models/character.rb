class Character < ActiveRecord::Base
  has_many :schematics

  validates :uuid, presence: true
  validates :uuid, uniqueness: true
end
