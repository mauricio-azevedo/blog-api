module Users
  class SessionsController < Devise::SessionsController
    def create
      @user = User.find_by(email: params[:user][:email])

      if @user&.valid_password?(params[:user][:password])
        sign_in(@user)
        @data = @user.slice(:id, :email, :name, :created_at, :updated_at)
        @message = 'Signed in successfully.'
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = 'Invalid Email or Password'
        render 'shared/response', status: :unauthorized
      end
    end

    def destroy
      @user_signed_out = user_signed_in?
      sign_out(current_user) if @user_signed_out
      respond_to_on_destroy
    end

    private

    def respond_to_on_destroy
      if @user_signed_out
        @message = 'Signed out successfully.'
        render 'shared/response', status: :ok
      else
        @ok = false
        @message = 'No active session found'
        render 'shared/response', status: :unprocessable_entity
      end
    end
  end
end
