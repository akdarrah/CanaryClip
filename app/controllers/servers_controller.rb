class ServersController < ApplicationController
  def show
    @server = Server.find_by_permalink!(params[:id])
  end
end
