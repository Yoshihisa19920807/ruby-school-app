class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :create_ransack_query, if: :user_signed_in?

  def create_ransack_query
    @courses_ransack = Course.ransack(params[:search_courses], search_key: :search_courses)
    # @courses_ransack = Course.ransack(params[:courses_search], search_key: :courses_search) #navbar search
  end

end
