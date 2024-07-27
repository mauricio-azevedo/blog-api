module Users
  class SessionsController < Devise::SessionsController
    include ActionController::Cookies

    before_action :set_default_response_format
    skip_before_action :verify_signed_out_user, only: :destroy

    respond_to :json

    def create
      self.resource = warden.authenticate!(auth_options)
      if resource
        sign_in(resource_name, resource)
        access_token = resource.generate_access_token
        refresh_token = resource.generate_refresh_token
        @message = 'Logged in successfully'
        @data = {
          user: resource.slice(:id, :email, :name, :created_at, :updated_at),
          access_token: access_token
        }
        cookies.signed[:refresh_token] = {
          value: refresh_token,
          httponly: true,
          secure: Rails.env.production?,
          same_site: Rails.env.production? ? :none : :lax
        }
        render 'shared/response', status: :ok
      else
        @message = 'Invalid credentials'
        @ok = false
        render 'shared/response', status: :unauthorized
      end
    end

    def destroy
      refresh_token = cookies.signed[:refresh_token]
      if refresh_token
        user = User.joins(:refresh_tokens).find_by(refresh_tokens: { token: refresh_token })
        if user
          cookies.delete(:refresh_token, {
            httponly: true,
            secure: Rails.env.production?,
            same_site: Rails.env.production? ? :none : :lax
          })
          sign_out(user)
          @message = 'Signed out successfully'
        else
          @message = 'User already signed out'
          @ok = false
        end
      else
        @message = 'User already signed out'
        @ok = false
      end
      render 'shared/response', status: :ok
    end

    private

    def set_default_response_format
      request.format = :json
    end
  end
end
