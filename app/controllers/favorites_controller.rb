class FavoritesController < ApplicationController
  before_filter :require_current_character
  before_filter :find_schematic

  def create
    @favorite = @schematic.favorites.build(character: current_character)

    if @favorite.save
      render json: @favorite, status: :ok
    else
      render json: @favorite.errors, status: :internal_server_error
    end
  end

  def destroy
    @favorite = @schematic.favorites.where(character: current_character).first
    @favorite.destroy
    
    render json: @favorite, status: :ok
  end

  private

  def find_schematic
    @schematic = Schematic.find(params[:schematic_id])
  end

end
