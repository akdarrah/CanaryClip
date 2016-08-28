class AddPermalinkToCharactersAndBlocks < ActiveRecord::Migration
  def change
    add_column :characters, :permalink, :string
    add_index :characters, :permalink

    add_column :blocks, :permalink, :string
    add_index :blocks, :permalink

    Character.all.each do |character|
      character.update_column :permalink, character.username.parameterize
    end

    Block.all.each do |block|
      block.update_column :permalink, block.name.parameterize
    end
  end
end
