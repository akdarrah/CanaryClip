class MarketingController < ApplicationController

  def index
    @marketing_render = Render.high_resolution.order('random()').first
    @schematic        = Schematic.published.order('random()').first
    @server           = Server.official
  end

end
