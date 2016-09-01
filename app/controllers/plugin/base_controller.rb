class Plugin::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :find_or_create_character

  private

  def render_plugin_text(text)
    render json: ["[MINEBUILD] #{text}"], status: :ok
  end

  def find_or_create_character
    character_uuid     = params[:plugin][:character_uuid]
    character_username = params[:plugin][:character_username]

    @character = Character.find_or_create_by!(username: character_username)
    @character.update_column :uuid, character_uuid
  end
end
