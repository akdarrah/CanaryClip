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
        "character_username" => @username
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
        "character_username" => @character.username
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
          "character_username" => nil
        }
    end
  end

end
