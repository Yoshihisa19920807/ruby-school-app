class HomeController < ApplicationController
  # skip authentication on top page
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @latest_courses = Course.latest
    @top_rated_courses = Course.top_rated
    @popular_courses = Course.popular
    # @activities = PublicActivity::Activity.all
  end
  
  # activity viewを表示時に読み込まれる
  def activity
    @activities = PublicActivity::Activity.all
    p "@activities.second.trackable"
    p @activities.second.trackable
  end

  def analytics
    @enrollments = Enrollment.all

  end
end
