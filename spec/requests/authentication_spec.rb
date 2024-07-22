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
        expect(json_response['message']).to eq('Signed in successfully')
        expect(json_response['data']).not_to be_empty
        expect(json_response['data']['token']).not_to be_nil
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

  describe "POST /users" do
    context "with valid parameters" do
      let(:valid_params) do
        {
          user: {
            name: "Test User",
            email: "test@example.com",
            password: "password",
            password_confirmation: "password"
          }
        }
      end

      it "creates a new user and returns a token" do
        post user_registration_path, params: valid_params, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Signed up successfully')
        expect(json_response['data']).not_to be_nil
        expect(json_response['data']['token']).not_to be_nil
        expect(json_response['data']['user']).not_to be_nil
        expect(json_response['data']['user']['email']).to eq('test@example.com')
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          user: {
            name: "",
            email: "invalid",
            password: "short",
            password_confirmation: "short"
          }
        }
      end

      it "does not create a new user and returns errors" do
        post user_registration_path, params: invalid_params, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('Email is invalid')
        expect(json_response['details']).to include("Name can't be blank")
        expect(json_response['details']).to include("Email is invalid")
        expect(json_response['details']).to include("Password is too short (minimum is 6 characters)")
        expect(json_response['data']).to be_nil
      end
    end
  end
end
