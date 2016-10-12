class MarketingController < ApplicationController

  def index
    @marketing_render = Render.high_resolution.order('random()').first
    @schematics       = Schematic.public.limit(3)
    @characters       = Character.order('random()').limit(6)
    @server           = Server.official
  end

end
