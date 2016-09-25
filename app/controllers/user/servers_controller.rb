class User::ServersController < ApplicationController
  load_and_authorize_resource find_by: :permalink

  DOWNLOAD_PATH = "#{Rails.root}/private/worldedit-bukkit-6.1.4-minebuild.jar"

  def show
    @schematics = @server.schematics.public.page(params[:page])
  end

  def new
    @server = current_user.owned_servers.new
  end

  def create
    @server = current_user.owned_servers.new(create_params)

    if @server.save
      redirect_to user_server_path @server
    else
      render action: :new
    end
  end

  def download
    send_file DOWNLOAD_PATH
  end

  private

  def create_params
    params.require(:server)
      .permit(:name, :hostname, :description)
  end
end
