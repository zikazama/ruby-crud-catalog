class ApplicationController < ActionController::Base
  before_action :require_authentication
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  private

  def require_authentication
    redirect_to login_path, alert: 'Please login first' unless current_user
  end
end
