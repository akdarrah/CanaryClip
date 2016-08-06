ActiveAdmin.register Block do
  menu priority: 5

  config.sort_order = 'id_asc'

  permit_params :minecraft_id, :name, :display_name, :stack_size,
    :diggable, :bounding_box, :transparent, :emit_light, :filter_light,
    :material, :hardness

  index do
    selectable_column
    id_column
    column :created_at
    column :minecraft_id
    column "Icon" do |block|
      if block.icon.present?
        image_tag(block.icon.url, class: "icon")
      else
        "&nbsp;".html_safe
      end
    end
    column :display_name
    actions
  end

  filter :id
  filter :created_at
  filter :minecraft_id
  filter :display_name

  form do |f|
    f.inputs "Block Details" do
      f.input :minecraft_id
      f.input :name
      f.input :display_name
      f.input :stack_size
      f.input :diggable
      f.input :bounding_box
      f.input :transparent
      f.input :emit_light
      f.input :filter_light
      f.input :material
      f.input :hardness
    end
    f.actions
  end

end
