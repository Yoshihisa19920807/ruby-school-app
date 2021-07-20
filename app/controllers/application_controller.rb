class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  
  include PublicActivity::StoreController #save current_user using gem public_activity
end
