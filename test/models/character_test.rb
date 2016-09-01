require 'test_helper'

class CharacterTest < ActiveSupport::TestCase

  def setup
  end

  test "Can be created with only a username" do
    @character = Character.new(username: UUID.generate)

    assert @character.valid?
    assert @character.save!
    assert @character.permalink.present?
  end

end
