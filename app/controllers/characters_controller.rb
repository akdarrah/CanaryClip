class CharactersController < ApplicationController
  def show
    @character  = Character.find_by_permalink!(params[:id])
    @schematics = @character.schematics.order("created_at desc").published.page(params[:page])
  end
end
