class EnrollmentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def index?
    # p "index???"
    # p "record___"
    # p @record
    # p "user___"
    # p @user
    @user.has_role?(:admin) if @user.present?
  end
  
  def show?
    # @user.has_role?(:admin) || @record.course.user_id == @user.id
  end
  
  def edit?
    # defined in application_policy.rb
    # p "____@record"
    # p @record
    
    @user.has_role?(:admin) || @record.course.user_id == @user.id if @user.present?
  end
  
  def update?
    @user.has_role?(:admin) || @record.course.user_id == @user.id if @user.present?
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
end
