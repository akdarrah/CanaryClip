class BlocksController < ApplicationController
  def show
    @block = Block.find_by_permalink!(params[:id])
  end
end
