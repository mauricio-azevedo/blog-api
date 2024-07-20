require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) { { title: 'Sample Post', body: 'This is a sample post' } }
  let(:invalid_attributes) { { title: '', body: '' } }

  before { sign_in user }

  describe 'GET /index' do
    it 'returns a success response' do
      Post.create! valid_attributes.merge(user: user)
      get posts_path, as: :json
      expect(response).to be_successful
      expect(json_response['ok']).to be true
      expect(json_response['data']).to be_an(Array)
      expect(json_response['message']).to eq('Posts retrieved successfully')
    end
  end

  describe 'GET /show' do
    it 'returns a success response' do
      post = Post.create! valid_attributes.merge(user: user)
      get post_path(post), as: :json
      expect(response).to be_successful
      expect(json_response['ok']).to be true
      expect(json_response['data']).to be_a(Hash)
      expect(json_response['message']).to eq('Post retrieved successfully')
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      it 'creates a new Post' do
        expect {
          post posts_path, params: { post: valid_attributes }, as: :json
        }.to change(Post, :count).by(1)
      end

      it 'renders a JSON response with the new post' do
        post posts_path, params: { post: valid_attributes }, as: :json
        expect(response).to have_http_status(:created)
        expect(json_response['ok']).to be true
        expect(json_response['data']).to be_a(Hash)
        expect(json_response['message']).to eq('Post created successfully')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new post' do
        post posts_path, params: { post: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('Failed to create post')
        expect(json_response['details']).to be_an(Array)
      end
    end
  end

  describe 'PUT /update' do
    context 'with valid params' do
      let(:new_attributes) { { title: 'Updated Title', body: 'Updated body' } }

      it 'updates the requested post' do
        post = Post.create! valid_attributes.merge(user: user)
        put post_path(post), params: { post: new_attributes }, as: :json
        post.reload
        expect(post.title).to eq('Updated Title')
        expect(post.body).to eq('Updated body')
      end

      it 'renders a JSON response with the post' do
        post = Post.create! valid_attributes.merge(user: user)
        put post_path(post), params: { post: new_attributes }, as: :json
        expect(response).to have_http_status(:ok)
        expect(json_response['ok']).to be true
        expect(json_response['data']).to be_a(Hash)
        expect(json_response['message']).to eq('Post updated successfully')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the post' do
        post = Post.create! valid_attributes.merge(user: user)
        put post_path(post), params: { post: invalid_attributes }, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['ok']).to be false
        expect(json_response['message']).to eq('Failed to update post')
        expect(json_response['details']).to be_an(Array)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested post' do
      post = Post.create! valid_attributes.merge(user: user)
      expect {
        delete post_path(post), as: :json
      }.to change(Post, :count).by(-1)
    end

    it 'renders a JSON response with the success message' do
      post = Post.create! valid_attributes.merge(user: user)
      delete post_path(post), as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response['ok']).to be true
      expect(json_response['message']).to eq('Post deleted successfully')
    end
  end
end
