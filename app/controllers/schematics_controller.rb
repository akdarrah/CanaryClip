class SchematicsController < ApplicationController

  before_filter :find_or_create_character, only: [:create]

  before_filter :find_schematic, only: [:show, :download]
  before_filter :log_impression, only: [:show, :download]
  before_filter :track_downloads, only: [:download]

  # We should come up with some way of verifying this request
  # is from a legit game server...
  protect_from_forgery :except => [:create, :download]

  def index
    @schematics = Schematic.published.chronological
  end

  def show
  end

  def create
    @schematic = Schematic.new(create_params)
    @schematic.character = @character

    respond_to do |format|
      if @schematic.save
        @schematic.collect_metadata!
        format.text { render json: ["Schematic permalink: #{@schematic.permalink}"], status: :ok }
      else
        format.text { render json: ["Schematic upload failed. Please try again."], status: :ok }
      end
    end
  end

  def download
    if @schematic.present?
      send_file @schematic.file.path
    else
      render :nothing => true, :status => :not_found
    end
  end

  private

  def create_params
    params.require(:schematic)
      .permit(:raw_schematic_data)
  end

  def find_or_create_character
    character_uuid     = params[:schematic].delete(:character_uuid)
    character_username = params[:schematic].delete(:character_username)

    @character = Character.find_or_create_by!(uuid: character_uuid)
    @character.update_column :username, character_username
  end

  def find_schematic
    @schematic = Schematic.find_by_permalink(params[:id])
  end

  def log_impression
    if @schematic.present?
      impressionist(@schematic)
    end
  end

  # The game plugin will send character info, but the interface
  # does not have to (think guest users).
  # TODO: Dry with find_or_create_character
  def track_downloads
    character_uuid     = params[:character_uuid]
    character_username = params[:character_username]

    if character_uuid.present?
      @character = Character.find_or_create_by!(uuid: character_uuid)

      if character_username.present?
        @character.update_column(:username, character_username)
      end

      TrackedDownload.create!(
        :character => @character,
        :schematic => @schematic
      )
    end
  end

end
