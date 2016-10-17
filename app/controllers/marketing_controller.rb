class MarketingController < ApplicationController

  def index
    @marketing_render = Render.high_resolution.order('random()').first
    @schematics       = Schematic.published.order('random()').limit(3)
    @server           = Server.official
  end

end
