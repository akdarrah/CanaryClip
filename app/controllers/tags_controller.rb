class TagsController < ApplicationController

  def show
    @tag_name   = params[:id]
    @schematics = Schematic.tagged_with(@tag_name).order("created_at desc").published.page(params[:page])
  end

end
