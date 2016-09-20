class DocumentationController < ApplicationController

  def quick_start
    @schematic = Schematic.order('random()').first
  end

end
