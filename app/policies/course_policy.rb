class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    @record.approved? && @record.published? ||
      @user && @user.has_role?(:admin) || @user && @record.user == @user ||
      @user && @user.has_role?(:admin) || @record.bought?(@user)
  end

  def edit?
    # defined in application_policy.rb
    # if user doesn't have admin role and the creater of the target course isn't the current_user , it raises an error
    @user.has_role?(:admin) || @record.user == @user if @user.present?
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user if @user.present?
  end

  def create?
    @user.has_role?(:teacher) if @user.present?
  end

  def new?
    @user.has_role?(:teacher) if @user.present?
  end

  def destroy?
    if @user.present?
      @user.has_role?(:admin) && @record.enrollments.none? ||
        @record.user == @user && @record.enrollments.none?
    end
  end

  def approve?
    @user.has_role?(:admin) if @user.present?
  end
end
