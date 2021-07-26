class LessonPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def show?
    @user.has_role?(:admin) || @record.course.user_id == @user.id
  end
  
  def edit?
    # defined in application_policy.rb
    # p "____@record"
    # p @record
    # p "edit?____"
    
    
    # p "@user.has_role?:admin"
    # p @user.has_role?:admin
    
    # p "_____@user"
    # p @user
    # p current_user
      # if user doesn't have admin role and the creater of the target course isn't the current_user , it raises an error
    @user.has_role?(:admin) || @record.course.user == @user if @user.present?
  end
  
  def update?
    @user.has_role?(:admin) || @record.course.user == @user if @user.present?
  end
  
  def create?
    @user.has_role?(:teacher) if @user.present?
  end
  
  def new?
    @user.has_role?(:teacher) if @user.present?
  end
  
  def destroy?
    @user.has_role?(:admin) || @record.course.user == @user if @user.present?
  end
  
end