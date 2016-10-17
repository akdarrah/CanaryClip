class BlocksController < ApplicationController
  def show
    @block      = Block.find_by_permalink!(params[:id])
    @schematics = @block.schematics.order("created_at desc").published.page(params[:page])
  end
end
