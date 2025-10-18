class DashboardController < ApplicationController
  skip_before_action :require_authentication, only: [:index]
  before_action :require_authentication_for_dashboard, only: [:index]

  def index
    if current_user
      @categories_count = Category.count
      @products_count = Product.count
      @recent_products = Product.includes(:category).order(created_at: :desc).limit(5)
    else
      redirect_to login_path, alert: 'Please login first'
    end
  end

  private

  def require_authentication_for_dashboard
    redirect_to login_path, alert: 'Please login first' unless current_user
  end
end
