class ServersController < ApplicationController

  def show
    @server     = Server.find_by_permalink!(params[:id])
    @schematics = @server.schematics.public.page(params[:page])
  end

end
