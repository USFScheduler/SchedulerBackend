class UsersController < ApplicationController
    def create
      user = User.new(user_params)
      if user.save
        render json: { message: 'User created successfully', user: UserSerializer.new(user).serialized_json }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

        # POST /login
    def login
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password])
        render json: { message: 'Login successful', user: UserSerializer.new(user).serialized_json }, status: :ok
      else
        render json: { message: 'Invalid email or password' }, status: :unauthorized
      end
    end

    private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  end