Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # Root and authentication routes
    root "dashboard#index" # Set the root route to dashboard#index
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Frontend dashboard routes
  get "dashboard", to: "dashboard#index"
  resources :categories
  resources :products

  # API v1 routes
  namespace :api do
    namespace :v1 do
      post 'login', to: 'sessions#create'
      
      resources :categories
      resources :products do
        collection do
          get :export
        end
      end
    end
  end
end
