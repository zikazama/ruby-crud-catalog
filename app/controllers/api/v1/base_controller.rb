module Api
  module V1
    class BaseController < ActionController::API
      before_action :current_user

      def current_user
        @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
      end

      def require_auth
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      end
    end
  end
end
