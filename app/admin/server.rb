ActiveAdmin.register Server do
  menu priority: 7

  config.sort_order = 'id_desc'

  permit_params :name, :hostname, :owner_user_id

  index do
    selectable_column
    id_column
    column :created_at
    column :name
    column :authenticity_token
    column :hostname
    column :claims_allowed
    column "Owner User Email" do |server|
      server.owner_user.email
    end
    actions
  end

  filter :id
  filter :created_at
  filter :permalink
  filter :name
  filter :authenticity_token
  filter :hostname
  filter :claims_allowed

  form do |f|
    f.inputs "Server Details" do
      f.input :name
      f.input :hostname
      f.input :owner_user_id
    end
    f.actions
  end

end
