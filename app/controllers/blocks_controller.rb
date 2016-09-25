class BlocksController < ApplicationController
  def show
    @block      = Block.find_by_permalink!(params[:id])
    @schematics = @block.schematics.page(params[:page])
  end
end
