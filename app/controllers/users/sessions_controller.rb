module Users
  class SessionsController < Devise::SessionsController
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
        sign_in(@user)
        @data = @user.slice(:id, :email, :name, :created_at, :updated_at)
        @message = 'Signed in successfully'
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = 'Invalid Email or Password'
        render 'shared/response', status: :unauthorized
      end
    rescue NoMethodError => e
      handle_invalid_params(e)
    end

    def destroy
      @user_signed_out = user_signed_in?
      sign_out(current_user) if @user_signed_out
      respond_to_on_destroy
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

    def respond_to_on_destroy
      if @user_signed_out
        @message = 'Signed out successfully'
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = 'No active session found'
        render 'shared/response', status: :unprocessable_entity
      end
    end
  end
end