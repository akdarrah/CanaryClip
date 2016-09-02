require 'test_helper'

class CharacterClaimTest < ActiveSupport::TestCase

  def setup
    @character_claim = create(:character_claim)
  end

  test "State machine life cycle for claim" do
    assert @character_claim.pending?
    assert @character_claim.claim!
    assert @character_claim.claimed?

    assert_raise(StateMachine::InvalidTransition){ @character_claim.expire! }
  end

  test "State machine life cycle for expiration" do
    assert @character_claim.pending?
    assert @character_claim.expire!
    assert @character_claim.expired?

    assert_raise(StateMachine::InvalidTransition){ @character_claim.claim! }
  end

  # find_or_create_character

  test "character is created if it does not exist" do
    @user               = create(:user)
    @character_username = UUID.generate

    refute Character.where(username: @character_username).exists?

    @character_claim = CharacterClaim.create!(
      :user               => @user,
      :character_username => @character_username
    )
    @character = Character.where(username: @character_username).first

    assert @character.present?
    assert_equal @character_claim.character, @character
    assert_equal @character_claim.character.username, @character.username
  end

  # assign_character_to_user

  test "character is assigned to the user when claimed" do
    @character                 = create(:character)
    @character_claim.character = @character
    @user                      = @character_claim.user

    assert @character.user.blank?
    refute @user.characters.exists?

    assert @character_claim.claim!

    assert_equal @user, @character.user
    assert @user.characters.exists?
  end

  test "character is set as users current_character if user doesn't have one" do
    @character                 = create(:character)
    @character_claim.character = @character
    @user                      = @character_claim.user

    assert @user.current_character.blank?
    assert @character_claim.claim!
    assert_equal @character, @user.reload.current_character
  end

  test "character is not set as users current_character if user already has a current_character" do
    @other_character           = create(:character)
    @character                 = create(:character)
    @character_claim.character = @character
    @user                      = @character_claim.user

    @user.update_column :current_character_id, @other_character
    assert @user.reload.current_character.present?

    assert @character_claim.claim!
    assert_not_equal @character, @user.reload.current_character
    assert_equal @other_character, @user.reload.current_character
  end

  # claim_with_username_verification

  test "claims if the username matches" do
    valid_username = @character_claim.character_username

    assert @character_claim.pending?
    @character_claim.claim_with_username_verification(valid_username)
    assert @character_claim.claimed?
  end

  test "does not claim if username is wrong" do
    assert @character_claim.pending?
    @character_claim.claim_with_username_verification('...')
    assert @character_claim.pending?
    refute @character_claim.claimed?
  end

end
