module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      user = User.find_by(email: params[:user][:email])

      if user&.valid_password?(params[:user][:password])
        sign_in(user)
        render json: { message: 'Signed in successfully', user: user.as_json(only: [:id, :email, :name, :created_at, :updated_at]) }, status: :ok
      else
        render json: { error: 'Invalid Email or Password' }, status: :unauthorized
      end
    end

    def destroy
      if user_signed_in?
        sign_out(current_user)
        render json: { message: 'Signed out successfully.' }, status: :ok
      else
        render json: { error: 'No active session found.' }, status: :unprocessable_entity
      end
    end

    private

    def respond_to_on_destroy
      if user_signed_in?
        render json: { message: 'Signed out successfully.' }, status: :ok
      else
        render json: { error: 'No active session found.' }, status: :unprocessable_entity
      end
    end
  end
end