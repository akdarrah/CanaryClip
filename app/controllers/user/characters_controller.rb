class User::CharactersController < ApplicationController

  def switch
    @character = current_user.characters.find_by_permalink!(params[:id])

    current_user.current_character = @character
    current_user.save!

    redirect_to :back
  end

end
