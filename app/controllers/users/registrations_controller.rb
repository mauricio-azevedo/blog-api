module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        @data = @user.slice(:id, :email, :name, :created_at, :updated_at)
        @message = 'Signed up successfully'
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = 'Sign up failed'
        @details = resource.errors.full_messages
        render 'shared/response', status: :unprocessable_entity
      end
    end
  end
end