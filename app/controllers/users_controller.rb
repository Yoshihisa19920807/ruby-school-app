class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  
  def index
    if current_user.has_role?(:admin)
      @users = User.all.order(created_at: :desc)
    else
      redirect_to root_path, alert: 'You do not have access'
    end
    
  end
  
  def edit
    
  end
  
  def update
    
    p "update"
    p "user_params"
    p user_params
    if @user.update(user_params)
      # redirect to users page
      redirect_to users_path, notice: 'User roles were successfully updated.'
    else
      # render edit page
      render :edit
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    # cover with {} to separate role_ids as an identical parameter 
    params.require(:user).permit({role_ids: []})
  end
end
