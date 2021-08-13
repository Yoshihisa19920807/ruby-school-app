class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  def edit?
    @user.has_role?(:admin) || @record.user == @user if @user.present?
  end
  def destroy?
    @user.has_role?(:admin) || @record.user == @user if @user.present?
  end
end
