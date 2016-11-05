require "test_helper"

class SchematicsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user           = create(:user)
    @character      = create(:character)
    @texture_pack   = create(:texture_pack)
    @schematic_file = Rack::Test::UploadedFile.new("#{Rails.root}/test/files/test.schematic", "application/octet-stream")
  end

  # SchematicsController#create

  test 'You must be logged in to create a schematic' do
    assert_no_difference('Schematic.count') do
      post :create,
        :schematic => {
          :file => @schematic_file
        }

      assert_response :found
      assert response.body.include?('users/sign_in')
    end
  end

  test 'User is associated to the uploaded schematic' do
    sign_in @user

    assert_difference('Schematic.count', 1) do
      post :create,
        :schematic => {
          :file            => @schematic_file,
          :texture_pack_id => @texture_pack.id
        }

      assert_response :found
    end

    @schematic = assigns[:schematic]
    assert @schematic.user.present?
    assert @schematic.character.blank?
    assert_equal @user, @schematic.user

    assert @schematic.collecting_metadata?
  end

  test 'Character can be associated to the uploaded schematic' do
    sign_in @user
    @user.update_column :current_character_id, @character

    assert_difference('Schematic.count', 1) do
      post :create,
        :schematic => {
          :file            => @schematic_file,
          :texture_pack_id => @texture_pack.id
        }

      assert_response :found
    end

    @schematic = assigns[:schematic]
    assert @schematic.user.present?
    assert @schematic.character.present?

    assert_equal @user, @schematic.user
    assert_equal @character, @schematic.character

    assert @schematic.collecting_metadata?
  end

end
