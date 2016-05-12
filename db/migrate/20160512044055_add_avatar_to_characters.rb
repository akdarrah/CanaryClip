class AddAvatarToCharacters < ActiveRecord::Migration
  def change
    add_attachment :characters, :avatar
  end
end
