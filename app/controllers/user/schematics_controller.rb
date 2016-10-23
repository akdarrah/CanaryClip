class User::SchematicsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource find_by: :permalink

  def index
    @schematics = current_user.schematics.order("created_at desc").page(params[:page])
  end

  def edit
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

  def update_params
    params.require(:schematic)
      .permit(:description)
  end

end
