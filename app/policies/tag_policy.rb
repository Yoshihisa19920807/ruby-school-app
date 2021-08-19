class TagPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    p "destroy_tag_policy"
    p "@user.has_role?:admin"
    p @user.has_role?:admin
    @user.has_role?:admin if @user.present?
  end
end
