require 'test_helper'

class FavoriteTest < ActiveSupport::TestCase

  def setup
    @schematic = create(:schematic)
    @favorite  = create(:favorite, schematic: @schematic)
    @character = @favorite.character
  end

  # Favorite.for_character

  test "for_character returns nil if no character is passed" do
    assert_nil Favorite.for_character(nil)
  end

  test "for_character returns nil if no favorite exists for the character passed" do
    @other_character = create(:character)
    assert_nil Favorite.for_character(@other_character)
  end

  test "for_character returns a result if a favorite exists for the character passed" do
    assert_equal @favorite, Favorite.for_character(@character)
  end

end
