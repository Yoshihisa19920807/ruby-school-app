class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :create_ransack_query

  def create_ransack_query
    @courses_ransack = Course.ransack(params[:search_courses], search_key: :search_courses)
    # @courses_ransack = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end

  include PublicActivity::StoreController #save current_user using gem public_activity
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
