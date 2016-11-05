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
    can [:index, :show], Schematic

    if user
      can [:new, :create, :download], Schematic
      can [:edit, :update, :destroy], Schematic do |schematic|
        schematic.admin_access?(user)
      end
    end
  end

  def server_abilities_for(user)
    if user
      can [:index, :new, :create, :download], Server
      can [:show, :edit, :update], Server do |server|
        server.owner_user == user
      end
    end
  end

end
