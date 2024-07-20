require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "returns a successful response" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.cookies).to include("_session_id")
      end
    end

    context "with invalid credentials" do
      it "returns an unauthorized response" do
        post user_session_path, params: { user: { email: user.email, password: "wrong_password" } }, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /users/sign_out" do
    context "with valid session" do
      it "signs out the user" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }, as: :json
        delete destroy_user_session_path, headers: { "Cookie" => response.headers["Set-Cookie"] }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Signed out successfully")
      end
    end

    context "without valid session" do
      it "returns an unprocessable entity response" do
        delete destroy_user_session_path, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("No active session found")
      end
    end
  end
end
