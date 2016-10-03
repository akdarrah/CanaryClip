module CharacterClaimsHelper

  def character_claim_state_label_class(state)
    case state
    when 'pending'
      'label-warning'
    when 'claimed'
      'label-success'
    when 'expired'
      'label-danger'
    end
  end

end
