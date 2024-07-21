module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :set_default_response_format

    def set_default_response_format
      request.format = :json
    end

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        @data = @user.slice(:id, :email, :name, :created_at, :updated_at)
        @message = 'Signed up successfully'
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