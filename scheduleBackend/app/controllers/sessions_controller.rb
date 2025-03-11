class SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        # Authentication successful
        render json: { message: 'Login successful', user: UserSerializer.new(user).serialized_json }, status: :ok
      else
        # Authentication failed
        render json: { message: 'Invalid email or password' }, status: :unauthorized
      end
    end
  
    def destroy
      # Handle logout logic here
    end
  end