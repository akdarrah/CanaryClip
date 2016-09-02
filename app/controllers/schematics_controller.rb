class SchematicsController < ApplicationController
  before_filter :find_schematic, only: [:show, :download]
  before_filter :log_impression, only: [:show, :download]

  def index
    @schematics = Schematic.published.chronological
  end

  def show
  end

  def download
    send_file @schematic.file.path
  end

  private

  def find_schematic
    @schematic = Schematic.find_by_permalink!(params[:id])
  end

  def log_impression
    impressionist(@schematic)
  end

end
