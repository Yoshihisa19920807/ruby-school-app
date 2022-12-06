class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    if @user.present?
      return @user.has_role?(:admin) || @record.id === @user.id
    end
  end

  def edit?
    @user.has_role?:admin if @user.present?
  end

  def update?
    @user.has_role?:admin if @user.present?
  end
end
