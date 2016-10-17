class ServersController < ApplicationController

  def show
    @server     = Server.find_by_permalink!(params[:id])
    @schematics = @server.schematics.order("created_at desc").published.page(params[:page])
  end

end
