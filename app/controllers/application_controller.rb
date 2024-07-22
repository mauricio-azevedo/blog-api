class ApplicationController < ActionController::API
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    if token
      decoded_token = JsonWebToken.decode(token)
      @current_user = User.find(decoded_token[:user_id])
    else
      render_error('Unauthorized', 'Missing or invalid token', :unauthorized)
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
    render_error('Invalid or Expired Token', e.message, :unauthorized)
  end

  def current_user
    @current_user
  end

  def render_error(message, details = [], status = :unprocessable_entity)
    @ok = false
    @message = message
    @details = Array(details)
    @data = nil
    render 'shared/response', status: status
  end
end
