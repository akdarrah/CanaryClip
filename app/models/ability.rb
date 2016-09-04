class Ability
  include CanCan::Ability

  def initialize(user)
    can [:index, :show, :download], Schematic

    if user
      if user.admin?
        can :manage, :all
      else
        can [:update], Schematic do |schematic|
          schematic.admin_access?(user)
        end
      end
    end

  end
end
