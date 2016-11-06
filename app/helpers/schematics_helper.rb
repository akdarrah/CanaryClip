module SchematicsHelper

  def schematic_state_label_class(state)
    case state
    when 'new'
      'label-default'
    when 'collecting_metadata'
      'label-info'
    when 'rendering'
      'label-warning'
    when 'published'
      'label-primary'
    end
  end

  def schematic_state_description(state)
    case state
    when 'new'
      content_tag :div, class: "alert alert-warning" do
        "This build is currently waiting to be analyzed."
      end
    when 'collecting_metadata'
      content_tag :div, class: "alert alert-warning" do
        "This build is currently being analyzed before it can be rendered."
      end
    when 'rendering'
      content_tag :div, class: "alert alert-warning" do
        "This build is being rendered&hellip; Rendering usually takes 5-10 minutes.".html_safe
      end
    when 'published'
      content_tag :div, class: "alert alert-success" do
        "#{fa_icon('check-circle ')} This build has been published and is discoverable by other users.".html_safe
      end
    end
  end

end
