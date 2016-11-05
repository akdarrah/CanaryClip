require 'test_helper'

class CharacterClaimBuildMigrationWorkerTest < ActiveSupport::TestCase

  def setup
    @user      = create(:user)
    @character = create(:character)
    @schematic = create(:schematic, character: @character)
  end

  # CharacterClaimBuildMigrationWorker#perform

  test "raises CharacterClaimBuildMigrationWorker::NoUserError if character does not have a user" do
    assert @character.user.blank?

    assert_raises CharacterClaimBuildMigrationWorker::NoUserError do
      CharacterClaimBuildMigrationWorker.new.perform(@character)
    end
  end

  test "assigns characters schematics to user" do
    @character.update_column :user_id, @user

    assert @schematic.user.blank?
    assert_equal @character, @schematic.character

    CharacterClaimBuildMigrationWorker.new.perform(@character)

    assert @schematic.reload
    assert @schematic.user.present?
    assert_equal @user, @schematic.user
  end

end
