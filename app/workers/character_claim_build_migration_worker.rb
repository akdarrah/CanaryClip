class CharacterClaimBuildMigrationWorker
  NoUserError = Class.new(RuntimeError)

  include Sidekiq::Worker

  def perform(character_id)
    # Give the transaction time to finish
    sleep 1
    
    @character = Character.find character_id
    @user      = @character.user

    raise NoUserError if @user.blank?

    @character.schematics.update_all :user_id => @user
  end
end
