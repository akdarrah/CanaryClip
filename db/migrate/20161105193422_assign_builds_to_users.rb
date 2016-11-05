class AssignBuildsToUsers < ActiveRecord::Migration
  def change
    Schematic.all.each do |schematic|
      if schematic.character.present?
        schematic.update_column :user_id, schematic.character.user_id
      end
    end
  end
end
