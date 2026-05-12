class ApplicationController < ActionController::API
  def current_user
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    if token
      decoded = JwtService.decode(token)
      @current_user ||= User.find(decoded[:user_id]) if decoded
    end

  rescue
    nil
  end

  def authenticate_user!
    render json: {error: 'you are not authorised buddy'}, status: :unauthorized unless current_user
  end
end
