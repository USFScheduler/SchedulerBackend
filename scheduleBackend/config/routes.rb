Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  post 'login', to: 'users#login' # Old login route

  # API v1 namespace
  namespace :api do
    namespace :v1 do
      # JWT Auth routes
      post   'login',   to: 'auth#login'
      post   'refresh', to: 'auth#refresh'
      delete 'logout',  to: 'sessions#destroy'

      # User routes
      resources :users, only: [:create, :update, :show, :destroy]
      get 'debug/users', to: 'users#debug_index' # for dev only

      # Task routes
      resources :tasks, only: [:index, :create]

      # Canvas API routes
      resources :canvas, only: [] do
        collection do
          get :assignments
          get :upcoming_assignments
          get :test_connection
        end
      end
    end
  end

  # Optional: root path
  # root "posts#index"
end
