class SessionsController < ApplicationController
  skip_before_action :require_authentication, only: [:new, :create]
  
  def new
    redirect_to dashboard_path if current_user
  end

  def create
    identifier = params[:identifier]
    password = params[:password]
    
    user = User.find_by('email = ? OR username = ?', identifier, identifier)
    
    if user&.authenticate(password)
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'Login successful!'
    else
      flash.now[:alert] = 'Invalid email/username or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logged out successfully'
  end
end
