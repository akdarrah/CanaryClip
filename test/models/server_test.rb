require 'test_helper'

class ServerTest < ActiveSupport::TestCase

  def setup
    @server = create(:server)
  end

  # Server#owner_character_must_belong_to_owner_user

  test "server is invalid if owner character doesn't belong to owner user" do
    @user      = @server.owner_user
    @character = create(:character)

    assert_not_equal @user, @character.user
    assert @server.valid?

    @server.owner_character = @character

    refute @server.valid?
  end

  test "server is valid if owner character does belong to owner user" do
    @user      = @server.owner_user
    @character = create(:character)

    @user.characters << @character

    @server.owner_character = @character
    assert @server.valid?
  end

end
