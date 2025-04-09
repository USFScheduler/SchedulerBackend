# app/controllers/users_controller.rb
class UsersController < ApplicationController
  # POST /users
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login (likely deprecated, handled by AuthController now)
  def login
    user = User.find_by(name: params[:name])
    if user&.authenticate(params[:password])
      render json: { message: 'Login successful' }, status: :ok
    else
      render json: { message: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # GET /debug/users — for development/debugging only
  def debug_index

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
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end

  #Might need to delete later
