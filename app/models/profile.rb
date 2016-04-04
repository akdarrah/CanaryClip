class Profile < ActiveRecord::Base
  has_many :schematics
  
  validates :username, :uuid, presence: true
  validates :uuid, uniqueness: true
end
