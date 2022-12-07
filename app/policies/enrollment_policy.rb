class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin) if @user.present?
  end

  def my_students?
    @user.has_role?(:admin) || @user.has_role?(:teacher) if @user.present?
  end

  def show?
    @user.has_role?(:admin) || @record.user_id == @user.id if @user.present?
  end

  def edit?
    # defined in application_policy.rb
    @user.has_role?(:admin) || @record.user_id == @user.id if @user.present?
  end

  def update?
    if @user.present?
      @user.has_role?(:admin) || @record.course.user_id == @user.id
    end
  end

  def create?
    # @record.course.user_id != @user.id if @user.present?
  end

  def new?
    # @record.course.user_id != @user.id if @user.present?
  end

  def destroy?
    @user.has_role?(:admin) if @user.present?
  end

  def certificate?
    # if lessons number === viewed lessons
    @record.course.lessons_count ==
      @record.course.user_lessons.where(user: @record.user).count
  end
end
