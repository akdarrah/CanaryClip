require 'test_helper'

class CharacterApiWorkerTest < ActiveSupport::TestCase

  def setup
    @character = create(:character, uuid: nil)

    @username = "onebert"
    @uuid     = UUID.generate(:compact)
    @file     = File.read("#{Rails.root}/test/files/character_avatar")
  end

  # CharacterApiWorker#perform

  test "fails if character cannot be found" do
    assert_raises ActiveRecord::RecordNotFound do
      CharacterApiWorker.new.perform(0)
    end
  end

  test "updates the character with API data" do
    @character.update_column :username, "onebert"

    assert @character.uuid.blank?
    assert @character.avatar.blank?

    stub_request(:get, "http://mcapi.ca/name/uuid/onebert").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => example_request_data.to_json, :headers => {})

    # Avatar Request
    stub_request(:get, "https://crafatar.com/avatars/#{@uuid}.png").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => @file, :headers => {})

    CharacterApiWorker.new.perform(@character.id)

    assert_equal @username, @character.reload.username
    assert_equal @uuid, @character.reload.uuid
  end

  private

  def example_request_data
    {
      "uuid"           => @uuid,
      "uuid_formatted" => "2266fd0f-3103-4b78-a3f4-90715e229036",
      "name"           => @username,
      "properties_decoded"=>[
        {
          "timestamp"   => 1474085777264,
          "profileId"   => "2266fd0f31034b78a3f490715e229036",
          "profileName" => "onebert",
          "textures"    => {
            "SKIN" => {
              "url" => "http://textures.minecraft.net/texture/38c4679633c29c4df21f678b1fb890298ce9e49da1d74cccb24e828cfa373"
            },
            "CAPE"=>{"url"=>nil}}}
      ],
     "cache"        => 1474088807,
     "cache_length" => "00:50:30"
   }
  end

end
