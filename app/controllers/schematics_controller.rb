class SchematicsController < ApplicationController
  load_and_authorize_resource find_by: :permalink

  before_filter :log_impression, only: [:show, :download]
  before_filter :track_downloads, only: [:download]

  def index
    @server     = Server.official
    @schematics = Schematic.published.chronological.page(params[:page])
  end

  def show
    @favorite = @schematic.favorites.for_character(current_character)
  end

  def download
    send_file @schematic.file.path
  end

  def update
    @schematic.attributes = update_params
    @schematic.save!

    redirect_to schematic_path(@schematic)
  end

  def destroy
    @schematic.destroy
    redirect_to schematics_path
  end

  private

  def log_impression
    impressionist(@schematic)
  end

  def track_downloads
    if current_character.present?
      TrackedDownload.create!(
        :character => current_character,
        :schematic => @schematic
      )
    end
  end

  def update_params
    params.require(:schematic)
      .permit(:description)
  end

end
