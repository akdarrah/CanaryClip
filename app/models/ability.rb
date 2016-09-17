class Ability
  include CanCan::Ability

  def initialize(user)
    schematic_abilities_for(user)
    server_abilities_for(user)

    if user.present? && user.admin?
      can :manage, :all
    end
  end

  def schematic_abilities_for(user)
    can [:index, :show, :download], Schematic

    if user
      can [:update], Schematic do |schematic|
        schematic.admin_access?(user)
      end
    end
  end

  def server_abilities_for(user)
    can [:show], Server

    if user
      can [:new, :create], Server
      can [:download], Server do |server|
        server.owner_user == user
      end
    end
  end

end
