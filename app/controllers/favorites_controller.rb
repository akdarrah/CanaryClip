class FavoritesController < ApplicationController
  before_filter :require_current_character
  before_filter :find_schematic

  def create
    @favorite = @schematic.favorites.build(character: current_character)
    @favorite.save

    redirect_to schematic_path(@schematic)
  end

  def destroy
    @favorite = @schematic.favorites.for_character(current_character)
    @favorite.destroy

    redirect_to schematic_path(@schematic)
  end

  private

  def find_schematic
    @schematic = Schematic.find_by_permalink!(params[:schematic_id])
  end

end
