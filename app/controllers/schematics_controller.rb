class SchematicsController < ApplicationController
  load_and_authorize_resource find_by: :permalink

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
    @schematic = current_user.schematics.new
    @schematic.character = current_character
  end

  def create
    @schematic = current_user.schematics.new(create_params)
    @schematic.character = current_character

    if @schematic.save
      @schematic.collect_metadata!
      flash[:success] = "Your build was uploaded successfully! It will be published once rendered (approximately 5-10 minutes)."
      redirect_to edit_user_schematic_path(@schematic)
    else
      render action: :new
    end
  end

  def download
    data = open(@schematic.file.url)
    send_data data.read, :filename => @schematic.file_file_name, :type => @schematic.file_content_type, :x_sendfile => true
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
