Rails.application.routes.draw do
  # Public-facing or top-level resources
  resources :users, only: [:show, :create, :update, :destroy]
  resources :tasks, only: [:index, :show, :create, :update, :destroy]

  # Optional traditional session routes (not needed with JWT)
  post '/login', to: 'users#login'       
  delete 'logout', to: 'sessions#destroy'
  get '/debug/users', to: 'users#debug_index'


  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1 namespace
  namespace :api do
    namespace :v1 do
      # JWT Auth routes
      post 'login', to: 'auth#login'
      post 'refresh', to: 'auth#refresh'
      delete 'logout', to: 'sessions#destroy'

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
