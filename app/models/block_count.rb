class BlockCount < ActiveRecord::Base
  belongs_to :schematic
  belongs_to :block

  validates :schematic, :block, :count, presence: true
  validates :block_id, uniqueness: {scope: :schematic_id}
  validates :count, numericality: {greater_than: 0, only_integer: true}
end
