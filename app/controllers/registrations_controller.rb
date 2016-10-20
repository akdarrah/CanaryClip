class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    @character_claim = resource.character_claims.first
    user_character_claim_path(@character_claim)
  end

  def sign_up_params
    params.require(:user)
      .permit(:email, :password, :password_confirmation, {:character_claims_attributes => [:character_username]})
  end
end
