class SchematicsController < ApplicationController
  before_filter :find_schematic, only: [:show, :download, :update]
  before_filter :log_impression, only: [:show, :download]
  before_filter :track_downloads, only: [:download]

  def index
    @schematics = Schematic.published.chronological
  end

  def show
    @favorite = @schematic.favorites.for_character(current_character)
  end

  def download
    send_file @schematic.file.path
  end

  # TODO: Permissions
  def update
    @schematic.attributes = update_params
    @schematic.save!

    redirect_to schematic_path(@schematic)
  end

  private

  def find_schematic
    @schematic = Schematic.find_by_permalink!(params[:id])
  end

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
