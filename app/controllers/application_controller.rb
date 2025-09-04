class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Authentication helpers
  before_action :current_user
  
  protected
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?
  
  def require_user
    unless logged_in?
      flash[:alert] = "You must be logged in to access that page"
      redirect_to login_path
    end
  end
  
  def require_guest
    if logged_in?
      flash[:notice] = "You are already logged in"
      redirect_to root_path
    end
  end
end
