class TrackedDownload < ActiveRecord::Base
  belongs_to :schematic
  belongs_to :character

  validates :schematic, :character, presence: true
end
