class MarketingController < ApplicationController

  def index
    @marketing_render = Render.high_resolution.order('random()').first
    @server           = Server.official
    @schematics       = Schematic.public.limit(3)
    @characters       = Character.order('random()').limit(6)
  end

end
