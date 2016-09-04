require 'test_helper'

class AbilityTest < ActiveSupport::TestCase

  def setup
    @user      = create(:user)
    @ability   = Ability.new(@user)
    @schematic = create(:schematic)
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

  test "Users with admin_access cannot update Schematic" do
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

end
