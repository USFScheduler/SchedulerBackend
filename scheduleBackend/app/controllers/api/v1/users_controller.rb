# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      # POST /api/v1/users
      def create
        user = User.new(user_params)
        if user.save
          render json: { message: 'User created successfully' }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/login (Optional, likely deprecated by AuthController)
      def login
        user = User.find_by(name: params[:name])
        if user&.authenticate(params[:password])
          render json: { message: 'Login successful' }, status: :ok
        else
          render json: { message: 'Invalid email or password' }, status: :unauthorized
        end
      end

      # GET /api/v1/debug/users — for development/debugging only
      def debug_index
        unless Rails.env.development?
          return render json: { error: 'Not available in production' }, status: :forbidden
        end

        users = User.all.map do |user|
          {
            id: user.id,
            name: user.name,
            email: user.email,
            password_digest: user.password_digest
          }
        end

        render json: users
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :canvas_api_token)
      end      
    end
  end
end
