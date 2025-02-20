require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { create(:user) }
  let(:post_record) { create(:post, user: user) }
  let(:valid_attributes) { { body: 'This is a sample comment' } }
  let(:invalid_attributes) { { body: '' } }
  let(:comment) { create(:comment, post: post_record, user: user) }
  let(:auth_headers) { user.create_new_auth_token }

  before do
    post user_session_path, params: { user: { email: user.email, password: user.password } }, as: :json
    @token = json_response['data']['token']
  end

  describe 'GET /posts/:post_id/comments' do
    it 'returns a success response' do
      comment # create the comment before the request
      get post_comments_path(post_record), headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response['ok']).to be true
      expect(json_response['message']).to eq('Comments retrieved successfully')
      expect(json_response['data']).not_to be_empty
    end
  end

  describe 'GET /posts/:post_id/comments/:id' do
    it 'returns a success response' do
      get post_comment_path(post_record, comment), headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to be_successful
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response['ok']).to be true
      expect(json_response['message']).to eq('Comment retrieved successfully')
      expect(json_response['data']).not_to be_empty
    end

    it 'returns a not found response when the comment does not exist' do
      get post_comment_path(post_record, id: 'nonexistent'), headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(json_response['ok']).to eq(false)
      expect(json_response['message']).to eq('Comment not found')
      expect(json_response['details']).to include("Couldn't find Comment with 'id'=nonexistent [WHERE \"comments\".\"post_id\" = $1]")
    end
  end

  describe 'POST /posts/:post_id/comments' do
    context 'with valid params' do
      it 'creates a new Comment' do
        expect {
          post post_comments_path(post_record), params: { comment: valid_attributes }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
        }.to change(Comment, :count).by(1)

        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Comment created successfully')
        expect(json_response['data']).not_to be_empty
      end

      it 'renders a JSON response with the new comment' do
        post post_comments_path(post_record), params: { comment: valid_attributes }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Comment created successfully')
        expect(json_response['data']).not_to be_empty
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new comment' do
        post post_comments_path(post_record), params: { comment: invalid_attributes }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('Failed to create comment')
        expect(json_response['details']).not_to be_empty
      end
    end
  end

  describe 'PUT /posts/:post_id/comments/:id' do
    context 'with valid params' do
      let(:new_attributes) { { body: 'Updated comment' } }

      it 'updates the requested comment' do
        put post_comment_path(post_record, comment), params: { comment: new_attributes }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
        comment.reload
        expect(comment.body).to eq('Updated comment')
        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Comment updated successfully')
        expect(json_response['data']).not_to be_empty
      end

      it 'renders a JSON response with the comment' do
        put post_comment_path(post_record, comment), params: { comment: new_attributes }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json_response['ok']).to be true
        expect(json_response['message']).to eq('Comment updated successfully')
        expect(json_response['data']).not_to be_empty
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the comment' do
        put post_comment_path(post_record, comment), params: { comment: invalid_attributes }, headers: { "Authorization" => "Bearer #{@token}" }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('Failed to update comment')
        expect(json_response['details']).not_to be_empty
      end
    end
  end

  describe 'DELETE /posts/:post_id/comments/:id' do
    it 'destroys the requested comment' do
      comment # create the comment before the request
      expect {
        delete post_comment_path(post_record, comment), headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      }.to change(Comment, :count).by(-1)

      expect(json_response['ok']).to be true
      expect(json_response['message']).to eq('Comment deleted successfully')
    end

    it 'renders a JSON response with the success message' do
      delete post_comment_path(post_record, comment), headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
      expect(json_response['ok']).to be true
      expect(json_response['message']).to eq('Comment deleted successfully')
    end

    it 'returns a not found response when the comment does not exist' do
      delete post_comment_path(post_record, id: 'nonexistent'), headers: { "Authorization" => "Bearer #{@token}" }, as: :json
      expect(response).to have_http_status(:not_found)
      expect(json_response['ok']).to eq(false)
      expect(json_response['message']).to eq('Comment not found')
      expect(json_response['details']).to include("Couldn't find Comment with 'id'=nonexistent [WHERE \"comments\".\"post_id\" = $1]")
    end
  end
end

def json_response
  JSON.parse(response.body)
end
