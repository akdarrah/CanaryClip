class Plugin::CharacterClaimsController < Plugin::BaseController
  before_action :verify_server_allows_claims
  before_filter :find_character_claim

  def claim
    if @character_claim.claim_with_username_verification(@character.username)
      render_plugin_text I18n.t('plugin.character_claims.claimed', username: @character.username)
    else
      render_plugin_text I18n.t('plugin.character_claims.check_username', username: @character.username)
    end
  end

  private

  def find_character_claim
    @character_claim = CharacterClaim.find_by_token(params[:id])

    if @character_claim.blank?
      render_plugin_text I18n.t('plugin.character_claims.not_found')
    end
  end

  def verify_server_allows_claims
    if !@server.claims_allowed?
      render_plugin_text I18n.t('plugin.character_claims.claims_not_allowed')
    end
  end

end
