require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  def setup
    @user      = create(:user)
    @ability   = Ability.new(@user)
    @schematic = create(:schematic)
    @server    = create(:server)
  end

  # Schematic

  test "All users can index Schematic" do
    @ability = Ability.new(nil)
    assert @ability.can?(:index, @schematic)
  end

  test "All users can show Schematic" do
    @ability = Ability.new(nil)
    assert @ability.can?(:show, @schematic)
  end

  test "All users can download Schematic" do
    @ability = Ability.new(nil)
    assert @ability.can?(:download, @schematic)
  end

  test "All users cannot update Schematic" do
    @ability = Ability.new(nil)
    refute @ability.can?(:update, @schematic)
  end

  test "Users without admin_access cannot update Schematic" do
    Schematic.any_instance
      .stubs(:admin_access?)
      .returns(false)

    refute @ability.can?(:update, @schematic)
  end

  test "Users with admin_access can update Schematic" do
    Schematic.any_instance
      .stubs(:admin_access?)
      .returns(true)

    assert @ability.can?(:update, @schematic)
  end

  test "Admin users can update Schematic" do
    @user    = create(:user, admin: true)
    @ability = Ability.new(@user)

    assert @ability.can?(:update, @schematic)
  end

  test "All users cannot destroy Schematic" do
    @ability = Ability.new(nil)
    refute @ability.can?(:destroy, @schematic)
  end

  test "Users without admin_access cannot destroy Schematic" do
    Schematic.any_instance
      .stubs(:admin_access?)
      .returns(false)

    refute @ability.can?(:destroy, @schematic)
  end

  test "Users with admin_access can destroy Schematic" do
    Schematic.any_instance
      .stubs(:admin_access?)
      .returns(true)

    assert @ability.can?(:destroy, @schematic)
  end

  test "Admin users can destroy Schematic" do
    @user    = create(:user, admin: true)
    @ability = Ability.new(@user)

    assert @ability.can?(:destroy, @schematic)
  end

  # Server

  test "All users can show Server" do
    @ability = Ability.new(nil)
    assert @ability.can?(:show, @server)
  end

  test 'All users cannot new Server' do
    @ability = Ability.new(nil)
    refute @ability.can?(:new, @server)
  end

  test 'Registered users can new Server' do
    @ability = Ability.new(@user)
    assert @ability.can?(:new, @server)
  end

  test 'All users cannot create Server' do
    @ability = Ability.new(nil)
    refute @ability.can?(:create, @server)
  end

  test 'Registered users can create Server' do
    @ability = Ability.new(@user)
    assert @ability.can?(:create, @server)
  end

  test "All users cannot download Server" do
    @ability = Ability.new(nil)
    refute @ability.can?(:download, @server)
  end

  test "Non-owner registered users cannot download Server" do
    @ability = Ability.new(@user)
    refute @ability.can?(:download, @server)
  end

  test "Owner user can download Server" do
    @user    = @server.owner_user
    @ability = Ability.new(@user)

    assert @ability.can?(:download, @server)
  end

end
