class SchematicsController < ApplicationController

  # We should come up with some way of verifying this request
  # is from a legit game server...
  protect_from_forgery :only => []

  def create
    @schematic = Schematic.new(create_params)

    # TODO: Fix this...
    @schematic.profile_id = 0

    respond_to do |format|
      if @schematic.save
        @schematic.create_world!
        format.text { render text: @schematic.permalink, status: :ok }
      else
        format.text { render nothing: true, status: :unprocessable_entity }
      end
    end
  end

  def download
    @schematic = Schematic.find_by_permalink(params[:id])

    if @schematic.present?
      send_file @schematic.file.path
    else
      render :nothing => true, :status => :not_found
    end
  end

  private

  def create_params
    params.require(:schematic)
      .permit(:raw_schematic_data, :name)
  end

end
