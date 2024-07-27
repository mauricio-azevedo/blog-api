class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Cookies

  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  private

  def render_error(message, details = [], status = :unprocessable_entity)
    @ok = false
    @message = message
    @details = Array(details)
    render 'shared/response', status: status
  end
end
