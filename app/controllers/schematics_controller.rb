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
    @favorite   = @schematic.favorites.for_character(current_character)
    @schematics = Schematic.order("random()").published.where.not(id: @schematic).limit(6)
  end

  def new
    @schematic = current_character.schematics.new
  end

  def create
    @schematic = current_character.schematics.new(create_params)

    if @schematic.save
      @schematic.collect_metadata!
      flash[:success] = "Your build was uploaded successfully! It will be published once rendered (approximately 5-10 minutes)."
      redirect_to edit_user_schematic_path(@schematic)
    else
      render action: :new
    end
  end

  def download
    send_file @schematic.file.path
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

  def create_params
    params.require(:schematic)
      .permit(:file, :texture_pack_id)
  end

end
