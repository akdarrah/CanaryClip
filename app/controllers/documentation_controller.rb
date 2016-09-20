class DocumentationController < ApplicationController

  def quick_start
    @schematic = Schematic.order('random()').first
  end

  def server_setup
    @uuid = UUID.generate(:compact)
  end

end
