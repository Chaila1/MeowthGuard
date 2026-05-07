class UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'created'}, status: :created
    else
      render json: { errors: user.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private

  def userParams
    params.require(:user).permit(:username, :email, :password)
  end 
end