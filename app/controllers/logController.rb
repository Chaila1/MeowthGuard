class LogController < ApplicationController
  
  def login
    loginParam = params[:login]

    user = User.find_by(email: loginParam) || User.find_by(username: loginParam)

    if user.nil?
      render json: { error: 'Invalid Login credentials please try again'}, status: :unauthorized
      return
    end

    if user.locked?
      render json: { error: 'You have been locked out of logging in due to too many failed attempts, please try again later.'}, status: :forbidden
      return
    end

    if user.authenticate(params[:password])
      user.resetLockout!
      token = JwtService.encode(user_id: user.id)
      render json:{token: token, username: user.username, email:user.email}
    else
      user.failedLogin
      attemptsLeft = User::MAX_LOG_ATTEMPTS - user.failed_attempts

      render json: {
        error: 'Invalid login please try again',
        attemptsLeft: attemptsLeft > 0 ? attemptsLeft : 0
      }, status: :unauthorized
    end
  end
end
