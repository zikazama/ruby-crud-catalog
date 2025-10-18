module Api
  module V1
    class SessionsController < BaseController
      def create
        identifier = params[:identifier]
        password = params[:password]
        user = User.find_by('email = ? OR username = ?', identifier, identifier)
        if user&.authenticate(password)
          session[:user_id] = user.id
          render json: { success: true, user: { id: user.id, email: user.email, username: user.username } }
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
    end
  end
end
