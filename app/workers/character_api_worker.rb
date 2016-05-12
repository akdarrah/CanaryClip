class CharacterApiWorker
  include Sidekiq::Worker

  IMAGE_API     = "https://crafatar.com/avatars"
  NAME_API_HOST = "mcapi.ca"

  def perform(character_id)
    @character = Character.find character_id
    data       = JSON.parse(Net::HTTP.get(NAME_API_HOST, "/name/uuid/#{@character.uuid}"))

    @character.avatar   = open("#{IMAGE_API}/#{@character.uuid}.png")
    @character.username = data['name']
    @character.save!
  end
end
