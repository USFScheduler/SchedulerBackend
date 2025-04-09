# app/controllers/api/v1/sessions_controller.rb
module Api
  module V1
    class SessionsController < ApplicationController
      # POST /api/v1/sessions (optional if you're using AuthController instead)
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          render json: {
            message: 'Login successful',
            user: UserSerializer.new(user).serialized_json
          }, status: :ok
        else
          render json: { message: 'Invalid email or password' }, status: :unauthorized
        end
      end

      # DELETE /api/v1/logout
      def destroy
        # Example: clearing stored refresh token (if you store it server-side)
        if current_user
