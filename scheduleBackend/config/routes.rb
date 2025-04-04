Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users, only: [:show, :create, :update, :destroy]
  resources :tasks, only: [:index, :show, :create, :update, :destroy]
  post '/login', to: 'users#login'
  delete 'logout', to: 'sessions#destroy'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
 # config/routes.rb
  namespace :api do
    namespace :v1 do
      resources :canvas, only: [] do
        collection do
          get :courses
          get 'courses/:course_id/assignments', to: 'canvas#assignments'
          get :upcoming_assignments
          get :calendar_events
          get :test_connection
        end
      end
    end
  end



end