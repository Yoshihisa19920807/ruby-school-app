class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def edit?
    # defined in application_policy.rb
    p "@record"
    p @record
    # p "edit?____"
    # p "@user.has_role?:admin"
    # p @user.has_role?:admin
    
    # if user doesn't have admin role and the creater of the target course isn't the current_user , it raises an error
    @user.has_role?:admin || @record.user == @user
  end
  
  def update?
    @user.has_role?:admin || @record.user == @user
  end
  
  def create?
    @user.has_role?:teacher
  end
  
  def new?
    @user.has_role?:teacher
  end
  
  def destroy?
    @user.has_role?:admin || @record.user == @user
  end
  
end
