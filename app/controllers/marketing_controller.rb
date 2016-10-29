class MarketingController < ApplicationController

  def index
    @marketing_render  = Render.high_resolution.order('random()').first
    @schematic         = Schematic.published.order('random()').first
    @server            = Server.official
    @anatomy_schematic = Schematic.find_by_permalink("xDlJWAV")
  end

end
