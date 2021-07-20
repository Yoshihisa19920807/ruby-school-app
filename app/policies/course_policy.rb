class CoursePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def edit?
    # p "edit?____"
    # p "@user.has_role?:admin"
    # p @user.has_role?:admin
    # if user doesn't have admin role, it raises an error
    @user.has_role?:admin
  end
end
