require "test_helper"

class PluginBaseControllerTest < ActionController::TestCase

  tests Plugin::CharacterClaimsController

  def setup
    @username = "onebert"
    @uuid     = UUID.generate(:compact)
  end

  test 'creates character if it does not exist' do
    refute Character.where(username: @username).exists?

    post :claim,
      :id     => "...",
      :plugin => {
        "character_uuid"     => @uuid,
        "character_username" => @username,
        "authenticity_token" => PLUGIN_AUTHENTICITY_TOKEN
      }

    assert_response :ok
    assert Character.where(username: @username).exists?
  end

  test 'does not create character if it already exists' do
    @character       = create(:character)
    @character_count = Character.count

    assert Character.where(username: @character.username).exists?

    post :claim,
      :id     => "...",
      :plugin => {
        "character_uuid"     => @character.uuid,
        "character_username" => @character.username,
        "authenticity_token" => PLUGIN_AUTHENTICITY_TOKEN
      }

    assert_response :ok
    assert Character.where(username: @character.username).exists?
    assert_equal @character_count, Character.count
  end

  # This would indicate Plugin Tampering
  test 'fails without a character_username in plugin params' do
    assert_raises ActiveRecord::RecordInvalid do
      post :claim,
        :id     => "...",
        :plugin => {
          "character_uuid"     => @uuid,
          "character_username" => nil,
          "authenticity_token" => PLUGIN_AUTHENTICITY_TOKEN
        }
    end
  end

  # Plugin::BaseController#verify_plugin_authenticity_token

  test 'Halts request when Plugin authenticity_token is not provided' do
    @character_claim = create(:character_claim)

    post :claim,
      :id     => @character_claim.token,
      :plugin => {
        "character_uuid"     => @uuid,
        "character_username" => @character_claim.character_username,
        "authenticity_token" => nil
      }

    assert_response :ok
    assert response.body.include?(I18n.t('plugin.base.invalid_authenticity_token'))
  end

  test 'Halts request when Plugin authenticity_token is incorrect' do
    @character_claim = create(:character_claim)

    post :claim,
      :id     => @character_claim.token,
      :plugin => {
        "character_uuid"     => @uuid,
        "character_username" => @character_claim.character_username,
        "authenticity_token" => UUID.generate
      }

    assert_response :ok
    assert response.body.include?(I18n.t('plugin.base.invalid_authenticity_token'))
  end

  test 'Does not create a character if the authenticity_token is incorrect' do
    @character_claim = create(:character_claim)
    refute Character.where(username: @username).exists?

    post :claim,
      :id     => @character_claim.token,
      :plugin => {
        "character_uuid"     => @uuid,
        "character_username" => @username,
        "authenticity_token" => UUID.generate
      }

    refute Character.where(username: @username).exists?
  end

end
