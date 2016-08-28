ActiveAdmin.register CharacterClaim do
  menu priority: 6

  config.sort_order = 'id_desc'

  permit_params :username, :uuid

  index do
    selectable_column
    id_column
    column :created_at
    column :character_username
    column :token
  end

  filter :id
  filter :created_at
  filter :character_username
  filter :token

  form do |f|
    f.inputs "Character Claim Details" do
      f.input :character_username
    end
    f.actions
  end

end
