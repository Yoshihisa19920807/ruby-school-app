class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    if @user.present?
      @user.has_role?(:admin) || @record.course.user == @user ||
        @record.course.bought?(@user)
    end
  end

  def edit?
    # defined in application_policy.rb
    # if user doesn't have admin role and the creater of the target course isn't the current_user , it raises an error
    @user.has_role?(:admin) || @record.course.user == @user if @user.present?
  end

  def update?
    @user.has_role?(:admin) || @record.course.user == @user if @user.present?
  end

  def create?
    @record.course.user_id == @user.id if @user.present?
  end

  def new?
    @record.course.user_id == @user.id if @user.present?
  end

  def destroy?
    @user.has_role?(:admin) || @record.course.user == @user if @user.present?
  end
end
