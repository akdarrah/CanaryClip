class User::ServersController < ApplicationController
  load_and_authorize_resource find_by: :permalink

  DOWNLOAD_PATH = "#{Rails.root}/private/worldedit-bukkit-6.1.4-canary_clip.jar"

  def index
    @servers = current_user.owned_servers
  end

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

  def edit
  end

  def update
    @server.attributes = editable_params

    if @server.save
      redirect_to user_server_path @server
    else
      render action: :edit
    end
  end

  def download
    send_file DOWNLOAD_PATH
  end

  private

  def editable_params
    params.require(:server)
      .permit(:name, :hostname, :description)
  end

  def create_params
    params.require(:server)
      .permit(:name, :hostname, :description)
  end
end
