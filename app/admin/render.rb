ActiveAdmin.register Render do
  menu priority: 3

  permit_params :schematic_id, :camera_angle, :samples_per_pixel, :resolution

  index do
    selectable_column
    id_column
    column :created_at
    column "Image" do |render|
      image_tag(render.file.url, class: "icon")
    end
    column :camera_angle
    column :samples_per_pixel
    column :resolution
    column :state
    actions
  end

  filter :id
  filter :camera_angle
  filter :samples_per_pixel
  filter :resolution
  filter :state

  form do |f|
    f.inputs "Render Details" do
      f.input :schematic_id
      f.input :camera_angle
      f.input :samples_per_pixel
      f.input :resolution
    end
    f.actions
  end
end
