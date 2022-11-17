class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def edit?
    p "user_edit____"
    @user.has_role?:admin if @user.present?
  end

  def update?
    @user.has_role?:admin if @user.present?
  end
end
