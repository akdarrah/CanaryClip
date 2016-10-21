class SchematicsController < ApplicationController
  load_and_authorize_resource find_by: :permalink

  before_filter :require_current_character, only: [:new, :create]
  before_filter :log_impression, only: [:show, :download]
  before_filter :track_downloads, only: [:download]

  def index
    @marketing_render = Render.high_resolution.order('random()').first
    @schematics       = Schematic.order("created_at desc").published.page(params[:page])
  end

  def show
    @favorite = @schematic.favorites.for_character(current_character)
  end

  def new
    @schematic = current_character.schematics.new
  end

  def create
    @schematic = current_character.schematics.new(create_params)

    if @schematic.save
      @schematic.collect_metadata!
      redirect_to schematics_path
    else
      render action: :new
    end
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

  def create_params
    params.require(:schematic)
      .permit(:file)
  end

end
