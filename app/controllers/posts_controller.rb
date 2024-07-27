class PostsController < ApplicationController
  before_action :set_post, only: [:show, :update, :destroy]

  def index
    # Log the cookies to check if the refresh token is being sent
    Rails.logger.info "Cookies: #{request.cookies.inspect}"
    Rails.logger.info "Signed Cookies: #{request.signed_cookies.inspect}"
    
    page = params[:page] || 1
    limit = params[:limit] || 10
    @posts = Post.includes(:user, comments: :user).order(created_at: :desc).page(page).per(limit)
    @mapped_posts = @posts.map do |post|
      post.as_json(include: {
        user: {},
        comments: {
          include: :user
        }
      }).merge("comments" => post.comments.order(created_at: :desc).map { |comment| comment.as_json(include: :user) })
    end
    @data = { posts: @mapped_posts, pagination: pagination_meta(@posts) }
    @message = 'Posts retrieved successfully'
    render 'shared/response', status: :ok
  end

  def show
    @data = @post.as_json(include: {
      user: {},
      comments: {
        include: :user
      }
    }).merge("comments" => @post.comments.order(created_at: :desc).map { |comment| comment.as_json(include: :user) })
    @message = 'Post retrieved successfully'
    render 'shared/response', status: :ok
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      @data = @post.as_json(include: {
        user: {},
        comments: {
          include: :user
        }
      }).merge("comments" => @post.comments.order(created_at: :desc).map { |comment| comment.as_json(include: :user) })
      @message = 'Post created successfully'
      render 'shared/response', status: :created
    else
      @ok = false
      @message = 'Failed to create post'
      @details = @post.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  rescue ArgumentError => e
    handle_error(e, 'Invalid post parameters', :bad_request)
  end

  def update
    if @post.update(post_params)
      @data = @post.as_json(include: {
        user: {},
        comments: {
          include: :user
        }
      }).merge("comments" => @post.comments.order(created_at: :desc).map { |comment| comment.as_json(include: :user) })
      @message = 'Post updated successfully'
      render 'shared/response', status: :ok
    else
      @ok = false
      @message = 'Failed to update post'
      @details = @post.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  rescue ArgumentError => e
    handle_error(e, 'Invalid post parameters', :bad_request)
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
    @post = Post.includes(:user, comments: :user).find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    handle_error(e, 'Post not found', :not_found)
  end

  def post_params
    params.require(:post).permit(:title, :body)
  rescue ActionController::ParameterMissing => e
    handle_error(e, 'Post parameters are missing', :bad_request)
  end

  def handle_error(error, message, status)
    unless performed?
      @ok = false
      @message = message
      @details = [error.message]
      render 'shared/response', status: status
    end
  end

  def pagination_meta(posts)
    {
      current_page: posts.current_page,
      next_page: posts.next_page,
      prev_page: posts.prev_page,
      total_pages: posts.total_pages,
      total_count: posts.total_count
    }
  end
end
