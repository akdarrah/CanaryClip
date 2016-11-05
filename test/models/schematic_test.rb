require 'test_helper'

class SchematicTest < ActiveSupport::TestCase

  def setup
    @schematic = create(:schematic)
  end

  test "State machine life cycle" do
    assert @schematic.new?
    assert_raise(StateMachine::InvalidTransition){ @schematic.render! }
    assert_raise(StateMachine::InvalidTransition){ @schematic.publish! }

    assert @schematic.collect_metadata!

    assert @schematic.collecting_metadata?
    assert_raise(StateMachine::InvalidTransition){ @schematic.collect_metadata! }
    assert_raise(StateMachine::InvalidTransition){ @schematic.publish! }

    assert @schematic.render!

    assert @schematic.rendering?
    assert_raise(StateMachine::InvalidTransition){ @schematic.collect_metadata! }
    assert_raise(StateMachine::InvalidTransition){ @schematic.render! }

    assert @schematic.publish!
    assert @schematic.published?
  end

  test "A Schematic::CollectMetadataWorker is queued when schematic is collecting metadata" do
    Schematic::CollectMetadataWorker
      .expects(:perform_async)
      .with(@schematic.id)
      .once

    assert @schematic.new?
    assert @schematic.collect_metadata!
    assert @schematic.collecting_metadata?
  end

  test "Renders are created and scheduled when transitioning to rendering" do
    Schematic.any_instance.stubs(:schedule_metadata_collection)

    refute @schematic.renders.exists?

    assert @schematic.new?
    assert @schematic.collect_metadata!
    assert @schematic.collecting_metadata?
    assert @schematic.render!
    assert @schematic.rendering?

    CameraAngle::AVAILABLE.each do |camera_angle|
      render = @schematic.renders.where(camera_angle: camera_angle).first

      assert render.present?
      assert render.scheduled?
    end
  end

  # Schematic#admin_access?

  test "user does not have admin access if they do not own the schematic" do
    @user = create(:user)

    refute @user.schematics.exists?
    refute @schematic.admin_access?(@user)
  end

  test "user does have admin access if they own the schematic" do
    @user = create(:user)
    @user.schematics << @schematic

    assert @schematic.admin_access?(@user)
  end

  # Schematic#destroyable

  test "cannot be destroyed if destroyable is false" do
    refute @schematic.destroyable
    @schematic.destroy

    assert @schematic.reload
  end

  test "can be destroyed if destroyable is true" do
    @schematic.stubs(:destroyable).returns(true)
    @schematic.destroy

    assert_raises ActiveRecord::RecordNotFound do
      assert @schematic.reload
    end
  end

  # Schematic#set_user_from_character

  test "does not set a user if no user is available on character" do
    @character = @schematic.character

    assert @character.user.blank?
    assert @schematic.user.blank?

    @schematic.save!

    assert @schematic.user.blank?
  end

  test "does set a user if no user is set on schematic, but the character has a user" do
    @character = @schematic.character
    @user      = create(:user)

    @character.update_column :user_id, @user
    @character.reload

    assert @character.user.present?
    assert @schematic.user.blank?

    @schematic.save!

    assert @schematic.user.present?
    assert_equal @user, @schematic.user
  end

  test "does not override user if character has a user, but schematic already has a user" do
    @character  = @schematic.character
    @user       = create(:user)
    @other_user = create(:user)

    @character.update_column :user_id, @user
    @character.reload

    @schematic.update_column :user_id, @other_user
    @schematic.reload

    assert @character.user.present?
    assert @schematic.user.present?

    @schematic.save!

    assert @schematic.user.present?
    assert_equal @other_user, @schematic.user
    assert_not_equal @user, @schematic.user
  end

end
