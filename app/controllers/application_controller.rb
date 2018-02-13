class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :is_admin?

  def current_user
  	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
  	!!current_user
  end

  def require_user
  	if !logged_in?
  		flash[:notice] = "You must be logged in to perform that action"
  		redirect_to login_path
  	end
  end

  def is_admin?
      !!current_user.admin? if logged_in? 
  end

end
