class HomeController < ApplicationController
  # skip authentication on top page
  skip_before_action :authenticate_user!, :only => [:index]
  def index
    @courses = Course.all.limit(3)
    @latest_courses = Course.all.limit(3).order(created_at: :desc)
    @activities = PublicActivity::Activity.all
    # p "@activities"
    # p @activities
    # p "@activities.first.course.create"
    # p @activities.first.key
  end
  
  # activity viewを表示時に読み込まれる
  def activity
    p "activity_____"
    @activities = PublicActivity::Activity.all
    p "@activities"
    p @activities
    p "@activities.second.trackable"
    p @activities.second.trackable
  end
end
