ActiveAdmin.register Character do
  menu priority: 4

  permit_params :username, :uuid

  index do
    selectable_column
    id_column
    column :created_at
    column "Avatar" do |character|
      image_tag(character.avatar.url, class: "icon")
    end
    column :username
    column :uuid
  end

  filter :id
  filter :username
  filter :uuid

  form do |f|
    f.inputs "Character Details" do
      f.input :username
      f.input :uuid
    end
    f.actions
  end

end
