# app/controllers/api/v1/auth_controller.rb
module Api
    module V1
      class AuthController < ApplicationController
        # POST /api/v1/login
        def login
            user = User.find_by(name: params[:name])
          
            if user&.authenticate(params[:password])
              access_token = encode_access_token(user)
              refresh_token = SecureRandom.hex(32)
          
              user.update(
                refresh_token: refresh_token,
                refresh_token_expires_at: 30.days.from_now
              )
          
              render json: {
                access_token: access_token,
                refresh_token: refresh_token,
                user: user
              }, status: :ok
            else
              render json: { error: 'Invalid credentials' }, status: :unauthorized
            end
          end
  
        # POST /api/v1/refresh
        def refresh
            user = User.find_by(refresh_token: params[:refresh_token])
          
            if user && user.refresh_token_expires_at && user.refresh_token_expires_at > Time.current
              new_access_token = encode_access_token(user)
          
              # OPTIONAL: rotate refresh token here for extra security
              new_refresh_token = SecureRandom.hex(32)
          
              user.update(
                refresh_token: new_refresh_token,
                refresh_token_expires_at: 30.days.from_now
              )
          
              render json: {
                access_token: new_access_token,
                refresh_token: new_refresh_token
              }, status: :ok
            else
              render json: { error: 'Invalid or expired refresh token' }, status: :unauthorized
            end
          end
          
  
        private
  
        def encode_access_token(user)
          payload = {
            user_id: user.id,
            exp: 15.minutes.from_now.to_i
          }
          JWT.encode(payload, Rails.application.secret_key_base)
        end
      end
    end
  end
  