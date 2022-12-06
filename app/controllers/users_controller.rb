class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def index
    if current_user.has_role?(:admin)
      # @users = User.all.order(created_at: :desc)
      @q = User.ransack(params[:q])
      @pagy, @users = pagy(@q.result(distinct: true))
    else
      redirect_to root_path, alert: 'You do not have the right to access'
    end
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    # p "update_user_"
    # p "self.roles___"
    # p user_params

    authorize @user
    # p "update"
    # p "user_params"
    # p user_params
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
    @user = User.friendly.find(params[:id])
  end

  def user_params
    # cover with {} to separate role_ids as an identical parameter 
    params.require(:user).permit({role_ids: []})
  end
end
