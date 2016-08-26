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

end
