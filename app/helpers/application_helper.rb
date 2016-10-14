module ApplicationHelper

  def title(text)
    content_for :title, text
  end

  def dimensions(schematic)
    width  = schematic.width
    length = schematic.length
    height = schematic.height
    title  = "#{length} Length &times; #{width} Width &times; #{height} Height".html_safe

    content_tag :span, title: title do
      "#{length}L &times; #{width}W &times; #{height}H".html_safe
    end
  end

  def formatted_date(timestamp)
    full_date = timestamp.strftime('%b %d %Y, %I:%M %p %Z')

    content_tag :span, title: full_date do
      "#{time_ago_in_words(timestamp)} ago"
    end
  end

  def block_icon_with_title(block_count)
    block = block_count.block
    count = block_count.count
    title = "#{block.display_name} &times; #{count}".html_safe

    image_tag block.icon.url, title: title, class: 'block-icon'
  end

end
