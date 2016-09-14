require "test_helper"

class PluginSchematicsControllerTest < ActionController::TestCase

  tests Plugin::SchematicsController

  def setup
    @server    = create(:server)
    @character = create(:character)
  end

  # Plugin::SchematicsController#create

  test 'Successful Schematic Creation' do
    refute @character.schematics.exists?

    post :create,
      :schematic => {
        :raw_schematic_data => "\u001F\x8B\b\u0000\u0000\u0000\u0000\u0000\u0000\u0000U\x8D\xCB\n\xC20\u0010E/\xA9}\xA4\xF8O\xA2Xp\xA1\xB8Ph\xED.Դ\u0019\x8DU\x9A|\xB6\x9F \xC4\xC4*\xD4ٝ\x993\xF7\xE6\xE0\x87Fɛ\xB0ԤHV\xFA\xDE\\\r\x80,b\u0011c`\xC8\xC0w\xC2ʁ\x846\x88\x97\xFA\xA1D\x8A\xD9ZX\u0011,|\x87c~$-\x8Bޒ%i\xF2q\x97\xFD1C\xB2\x95}g\u0015X\u0004^\u0016\xFB\xB65\xD2VιׄOA\u001Dy\xA0\x8E\xFA\xDA\xE3sr\xAF\xBD\xEF|\xD4FR\xA7\xEC/\uA8C6\xD7ń+\xCF\u0017\x86\xB8\xA4s(\xC5\eO\x8E\u0011|\xEC\u0000\u0000\u0000"
      },
      :plugin    => {
        :character_uuid     => @character.uuid,
        :character_username => @character.username,
        :authenticity_token => @server.authenticity_token
      }

    @schematic = assigns[:schematic]

    assert_response :ok
    assert response.body.include?('Schematic Upload Success')
    assert response.body.include?(@schematic.permalink)

    assert @character.schematics.exists?
    assert_equal @schematic.character, @character
    assert @schematic.collecting_metadata?
  end

  test 'Schematic Creation with validation error' do
    begin
      Schematic.any_instance.stubs(:valid?).returns(false)

      refute @character.schematics.exists?

      post :create,
        :schematic => {
          :raw_schematic_data => "\u001F\x8B\b\u0000\u0000\u0000\u0000\u0000\u0000\u0000U\x8D\xCB\n\xC20\u0010E/\xA9}\xA4\xF8O\xA2Xp\xA1\xB8Ph\xED.Դ\u0019\x8DU\x9A|\xB6\x9F \xC4\xC4*\xD4ٝ\x993\xF7\xE6\xE0\x87Fɛ\xB0ԤHV\xFA\xDE\\\r\x80,b\u0011c`\xC8\xC0w\xC2ʁ\x846\x88\x97\xFA\xA1D\x8A\xD9ZX\u0011,|\x87c~$-\x8Bޒ%i\xF2q\x97\xFD1C\xB2\x95}g\u0015X\u0004^\u0016\xFB\xB65\xD2VιׄOA\u001Dy\xA0\x8E\xFA\xDA\xE3sr\xAF\xBD\xEF|\xD4FR\xA7\xEC/\uA8C6\xD7ń+\xCF\u0017\x86\xB8\xA4s(\xC5\eO\x8E\u0011|\xEC\u0000\u0000\u0000"
        },
        :plugin    => {
          :character_uuid     => @character.uuid,
          :character_username => @character.username,
          :authenticity_token => @server.authenticity_token
        }

      @schematic = assigns[:schematic]

      assert_response :ok
      assert response.body.include?(I18n.t('plugin.schematics.validation_error'))

      refute @character.schematics.exists?
      assert @schematic.new_record?
    ensure
      @schematic.send(:delete_temporary_file)
    end
  end

  # Plugin::SchematicsController#download

  test "when schematic cannot be found with given short code" do
    @permalink = UUID.generate(:compact)

    refute Schematic.where(permalink: @permalink).exists?

    get :download,
      :id     => @permalink,
      :plugin => {
        :character_username => @character.username,
        :character_uuid     => @character.uuid,
        :authenticity_token => @server.authenticity_token
      }

    assert_response :ok
    assert response.body.include?('Schematic not found')
    assert assigns[:schematic].blank?
  end

  test "When schematic can be found an impression is logged" do
    @schematic = create(:schematic)

    refute @schematic.impressions.exists?

    get :download,
      :id     => @schematic.permalink,
      :plugin => {
        :character_username => @character.username,
        :character_uuid     => @character.uuid,
        :authenticity_token => @server.authenticity_token
      }

    assert_equal 1, @schematic.impressions.count
    assert_equal 'download', @schematic.impressions.first.action_name
  end

  test "When schematic can be found a TrackedDownload is created" do
    @schematic = create(:schematic)

    refute @schematic.tracked_downloads.exists?

    get :download,
      :id     => @schematic.permalink,
      :plugin => {
        :character_username => @character.username,
        :character_uuid     => @character.uuid,
        :authenticity_token => @server.authenticity_token
      }

    assert_equal 1, @schematic.tracked_downloads.count
    assert_equal @character, @schematic.tracked_downloads.first.character
  end

  test "When schematic can be found, the file is sent as response" do
    @schematic = create(:schematic)

    get :download,
      :id     => @schematic.permalink,
      :plugin => {
        :character_username => @character.username,
        :character_uuid     => @character.uuid,
        :authenticity_token => @server.authenticity_token
      }

    assert_response :ok
  end

end
