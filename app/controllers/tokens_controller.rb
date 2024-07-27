class TokensController < ApplicationController
  before_action :authenticate_user!

  def create
    refresh_token = cookies.signed[:refresh_token]
    if current_user.refresh_token_valid?(refresh_token)
      token_record = current_user.refresh_tokens.find_by(token: refresh_token)
      token_record.destroy if token_record
      access_token = resource.generate_access_token
      refresh_token = resource.generate_refresh_token
      @message = 'Token refreshed successfully'
      @data = {
        access_token: access_token
      }
      cookies.signed[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }
      render 'shared/response', status: :ok
    else
      @message = 'Invalid refresh token'
      @ok = false
      @details = ['The provided refresh token is invalid or expired.']
      render 'shared/response', status: :unauthorized
    end
  end
end
