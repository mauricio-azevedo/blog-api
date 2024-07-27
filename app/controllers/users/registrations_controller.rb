module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_default_response_format

    def set_default_response_format
      request.format = :json
    end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        access_token = resource.generate_access_token
        refresh_token = resource.generate_refresh_token
        @data = {
          user: resource.slice(:id, :email, :name, :created_at, :updated_at),
          access_token: access_token
        }
        @message = 'Signed up successfully'
        cookies.signed[:refresh_token] = {
          value: refresh_token,
          httponly: true,
          secure: Rails.env.production?,
          same_site: :strict
        }
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = resource.errors.full_messages[0]
        @details = resource.errors.full_messages
        render 'shared/response', status: :unprocessable_entity
      end
    end
  end
end
