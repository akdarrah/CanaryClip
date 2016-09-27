class Plugin::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_filter :verify_plugin_authenticity_token
  before_filter :find_or_create_character

  private

  def render_plugin_text(text)
    render json: ["[CANARYCLIP] #{text}"], status: :ok
  end

  def verify_plugin_authenticity_token
    @server = Server.find_by_authenticity_token(params[:plugin][:authenticity_token])

    if @server.blank?
      render_plugin_text I18n.t('plugin.base.invalid_authenticity_token')
    end
  end

  def find_or_create_character
    character_uuid     = params[:plugin][:character_uuid]
    character_username = params[:plugin][:character_username]

    @character = Character.find_or_create_by!(username: character_username)
    @character.update_column :uuid, character_uuid
  end
end
