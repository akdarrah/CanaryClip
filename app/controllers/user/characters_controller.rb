class User::CharactersController < ApplicationController
  before_action :authenticate_user!

  def switch
    @character = current_user.characters.find_by_permalink!(params[:id])

    current_user.current_character = @character
    current_user.save!

    redirect_to :back
  end

end
