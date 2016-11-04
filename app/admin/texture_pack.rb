ActiveAdmin.register TexturePack do
  menu priority: 8

  config.sort_order = 'id_desc'

  permit_params :name, :zip_file

  index do
    selectable_column
    id_column
    column :created_at
    column :name
    column :permalink
    actions
  end

  filter :id
  filter :created_at
  filter :permalink
  filter :name

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "TexturePack Details" do
      f.input :name
      f.input :zip_file, :as => :file
    end
    f.actions
  end

end
