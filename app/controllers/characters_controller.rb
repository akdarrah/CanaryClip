class CharactersController < ApplicationController
  def show
    @character = Character.find_by_permalink!(params[:id])
  end
end
