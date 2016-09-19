class DocumentationController < ApplicationController

  def quick_start
    @schematic = Schematic.order('random()').first
  end

  def plugin
  end

end
