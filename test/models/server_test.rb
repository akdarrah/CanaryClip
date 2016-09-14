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

  # Server#hostname_is_dns_hostname_or_ip_address

  test "ip addresses without a port are allowed" do
    @server.hostname = "45.35.171.145"
    assert @server.valid?
  end

  test "ip addresses with a port are allowed" do
    @server.hostname = "45.35.171.145:25654"
    assert @server.valid?
  end

  test "dns hostnames are allowed" do
    @server.hostname = "play.shaded.gg"
    assert @server.valid?
  end

  test "other hostnames are not allowed" do
    @server.hostname = UUID.generate
    refute @server.valid?
  end

end
