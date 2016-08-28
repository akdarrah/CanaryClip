class CharacterClaimsController < ApplicationController
  before_action :authenticate_user!

  def new
    @character_claim = current_user.character_claims.new
  end

end
