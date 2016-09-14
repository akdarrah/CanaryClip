require "test_helper"

class PluginCharacterClaimsControllerTest < ActionController::TestCase

  tests Plugin::CharacterClaimsController

  def setup
    @character_claim = create(:character_claim)
    @username        = "onebert"
    @uuid            = UUID.generate(:compact)
    @server          = create(:server, claims_allowed: true)
  end

  test 'does not allow character claims if claims_allowed is false on the server' do
    @user      = @character_claim.user
    @character = @character_claim.character

    @server.update_column :claims_allowed, false

    refute @user.characters.exists?
    refute @server.claims_allowed?

    post :claim,
      :id     => @character_claim.token,
      :plugin => {
        "character_uuid"     => @character.uuid,
        "character_username" => @character.username,
        "authenticity_token" => @server.authenticity_token
      }

    assert_response :ok
    assert response.body.include? I18n.t('plugin.character_claims.claims_not_allowed')
  end

  test 'rejects requests with an unknown claim code' do
    @unknown_claim_code = UUID.generate
    refute CharacterClaim.where(token: @unknown_claim_code).exists?

    post :claim,
      :id     => @unknown_claim_code,
      :plugin => {
        "character_uuid"     => @uuid,
        "character_username" => @username,
        "authenticity_token" => @server.authenticity_token
      }

    assert_response :ok
    assert response.body.include? I18n.t('plugin.character_claims.not_found')
  end

  test 'claim fails if username does not match' do
    @wrong_username = UUID.generate

    post :claim,
      :id     => @character_claim.token,
      :plugin => {
        "character_uuid"     => @uuid,
        "character_username" => @wrong_username,
        "authenticity_token" => @server.authenticity_token
      }

    assert_response :ok
    assert response.body.include? 'Character Claim failed'
    assert @character_claim.reload.pending?
  end

  test 'claim is successful if username matches' do
    @user      = @character_claim.user
    @character = @character_claim.character

    refute @user.characters.exists?

    post :claim,
      :id     => @character_claim.token,
      :plugin => {
        "character_uuid"     => @character.uuid,
        "character_username" => @character.username,
        "authenticity_token" => @server.authenticity_token
      }

    assert_response :ok
    assert @character_claim.reload.claimed?
    assert_equal @user, @character.reload.user
  end

end
