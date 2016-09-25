class CharactersController < ApplicationController
  def show
    @character  = Character.find_by_permalink!(params[:id])
    @schematics = @character.schematics.public.page(params[:page])
  end
end
