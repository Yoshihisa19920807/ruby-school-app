class HomeController < ApplicationController
  # skip authentication on top page
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @latest_courses = Course.latest.published.approved
    @top_rated_courses = Course.top_rated.published.approved
    @popular_courses = Course.popular.published.approved
    # @purchased_courses = Course.includes(:enrollments).where(enrollments: {user: current_user})
    @purchased_courses = Course.purchased(current_user)
    # @activities = PublicActivity::Activity.all
  end
  
  # activity viewを表示時に読み込まれる
  def activity
    if current_user.has_role?(:admin)
      @pagy, @activities = pagy(PublicActivity::Activity.all)
    else
      redirect_to root_path, alert: "You are not authorized to perform this action"
    end
  end

  def analytics
    if current_user.has_role?(:admin)
      # @enrollments = Enrollment.all
    else
      redirect_to root_path, alert: "You are not authorized to perform this action"
    end
  end

  def privacy_policy
  end

  # def users_per_day
  #   render json: User.group_by_day(:created_at).count
  # end

  # def enrollments_per_day
  #     render json: Enrollment.group_by_day(:created_at).count
  # end

  # def courses_per_day
  #     render json: Course.group_by_day(:created_at).count
  # end

end
