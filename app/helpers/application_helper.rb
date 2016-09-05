module ApplicationHelper

  def dimensions(schematic)
    width  = schematic.width
    length = schematic.length
    height = schematic.height
    title  = "#{length} Length &times; #{width} Width &times; #{height} Height".html_safe

    content_tag :span, title: title do
      "#{length}L &times; #{width}W &times; #{height}H".html_safe
    end
  end

end
