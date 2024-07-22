module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_default_response_format

    def set_default_response_format
      request.format = :json
    end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        token = resource.generate_jwt
        @data = { user: resource.slice(:id, :email, :name, :created_at, :updated_at), token: token }
        @message = 'Signed up successfully'
        @ok = true
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = resource.errors.full_messages[0]
        @details = resource.errors.full_messages
        @data = nil
        render 'shared/response', status: :unprocessable_entity
      end
    end
  end
end
