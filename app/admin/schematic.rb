ActiveAdmin.register Schematic do
  menu priority: 1

  config.sort_order = 'id_desc'

  permit_params :character_id, :permalink

  index do
    selectable_column
    id_column
    column :created_at
    column "Primary Render" do |schematic|
      image_tag(schematic.primary_render.file.url, class: "icon")
    end
    column :permalink
    column :state
  end

  filter :id
  filter :created_at
  filter :permalink
  filter :width
  filter :length
  filter :height
  filter :state

  form do |f|
    f.inputs "Schematic Details" do
      f.input :character_id
      f.input :permalink
    end
    f.actions
  end

end
