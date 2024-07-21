class ApplicationController < ActionController::API
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :log_session_details

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def log_session_details
    Rails.logger.info "Session ID: #{session.id}"
    Rails.logger.info "Session Data: #{session.to_hash}"
  end
end
