class CharacterClaimsController < ApplicationController
  before_action :authenticate_user!

  def index
    @character_claims = current_user.character_claims
  end

  def show
    @character_claim = current_user.character_claims.find_by_token!(params[:id])
  end

  def new
    @character_claim = current_user.character_claims.new
  end

  def create
    @character_claim = current_user.character_claims.new
    @character_claim.attributes = create_params

    if @character_claim.save
      redirect_to character_claim_path @character_claim
    else
      render action: :new
    end
  end

  private

  def create_params
    params.require(:character_claim)
      .permit(:character_username)
  end
end
