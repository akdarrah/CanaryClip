class ServersController < ApplicationController
  load_and_authorize_resource find_by: :permalink

  DOWNLOAD_PATH = "#{Rails.root}/private/worldedit-bukkit-6.1.4-minebuild.jar"

  def show
  end

  def download
    send_file DOWNLOAD_PATH
  end
end
