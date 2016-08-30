class Plugin::CharacterClaimsController < ApplicationController

  # TODO: Authenticate by token or Server IP / PORT
  protect_from_forgery :except => [:claim]

  def claim
    raise params.inspect

    @character_claim = CharacterClaim.find_by_token!(params[:id])

    # TODO: Should do username verification
    if @character_claim.claim!
      format.text { render json: ["Character Claimed!"], status: :ok }
    else
      format.text { render json: ["Character Claim failed. Please try again."], status: :ok }
    end
  end

end
