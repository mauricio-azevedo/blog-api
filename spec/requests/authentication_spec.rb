require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "returns a successful response" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Signed in successfully.')
        expect(json_response['data']).not_to be_empty
        expect(response.cookies).to include("_session_id")
      end
    end

    context "with invalid credentials" do
      it "returns an unauthorized response" do
        post user_session_path, params: { user: { email: user.email, password: "wrong_password" } }, as: :json
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('Invalid Email or Password')
        expect(json_response['data']).to be_nil
      end
    end
  end

  describe "DELETE /users/sign_out" do
    context "with valid session" do
      it "signs out the user" do
        post user_session_path, params: { user: { email: user.email, password: user.password } }, as: :json
        delete destroy_user_session_path, headers: { "Cookie" => response.headers["Set-Cookie"] }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Signed out successfully.')
        expect(json_response['data']).to be_nil
      end
    end

    context "without valid session" do
      it "returns an unprocessable entity response" do
        delete destroy_user_session_path, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('No active session found')
        expect(json_response['data']).to be_nil
      end
    end
  end
end
