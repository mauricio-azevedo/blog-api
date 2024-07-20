class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    @posts = Post.all
    @data = @posts
    @message = 'Posts retrieved successfully'
    render 'shared/response', status: :ok
  end

  def show
    @data = @post
    @message = 'Post retrieved successfully'
    render 'shared/response', status: :ok
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      @data = @post.slice(:id, :title, :body, :created_at, :updated_at)
      @message = 'Post created successfully'
      render 'shared/response', status: :created
    else
      @ok = false
      @message = 'Failed to create post'
      @details = @post.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      @data = @post.slice(:id, :title, :body, :created_at, :updated_at)
      @message = 'Post updated successfully'
      render 'shared/response', status: :ok
    else
      @ok = false
      @message = 'Failed to update post'
      @details = @post.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      @message = 'Post deleted successfully'
      render 'shared/response', status: :ok
    else
      @ok = false
      @message = 'Failed to delete post'
      render 'shared/response', status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])

  rescue ActiveRecord::RecordNotFound => e
    @ok = false
    @data = nil
    @message = 'Post not found'
    @details = [e.message]

    render 'shared/response', status: :not_found
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
