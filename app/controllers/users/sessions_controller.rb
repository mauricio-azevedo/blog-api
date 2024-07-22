module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :authenticate_user!, only: [:create]
    before_action :set_default_response_format

    def set_default_response_format
      request.format = :json
    end

    def create
      if params[:user].nil?
        handle_missing_params
        return
      end

      @user = User.find_by(email: params[:user][:email])

      if @user&.valid_password?(params[:user][:password])
        token = @user.generate_jwt
        @data = { user: @user.slice(:id, :email, :name, :created_at, :updated_at), token: token }
        @message = 'Signed in successfully'
        @ok = true
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = 'Invalid Email or Password'
        @data = nil
        @details = []
        render 'shared/response', status: :unauthorized
      end
    rescue NoMethodError => e
      handle_invalid_params(e)
    end

    private

    def handle_missing_params
      @ok = false
      @message = 'Missing user parameters'
      @details = ['The user parameter is required and was not provided']
      render 'shared/response', status: :bad_request
    end

    def handle_invalid_params(error)
      @ok = false
      @message = 'Invalid request parameters'
      @details = [error.message]
      render 'shared/response', status: :unprocessable_entity
    end
  end
end
