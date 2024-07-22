class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    @comments = @post.comments.includes(:user)
    @data = @comments.as_json(include: :user)
    @message = 'Comments retrieved successfully'
    render 'shared/response', status: :ok
  end

  def show
    @data = @comment.as_json(include: :user)
    @message = 'Comment retrieved successfully'
    render 'shared/response', status: :ok
  end

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      @data = @comment.as_json(include: :user)
      @message = 'Comment created successfully'
      render 'shared/response', status: :created
    else
      @ok = false
      @message = 'Failed to create comment'
      @details = @comment.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  rescue NoMethodError => e
    handle_error(e, 'Invalid comment parameters', :bad_request)
  end

  def update
    if @comment.update(comment_params)
      @data = @comment.as_json(include: :user)
      @message = 'Comment updated successfully'
      render 'shared/response', status: :ok
    else
      @ok = false
      @message = 'Failed to update comment'
      @details = @comment.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  rescue ArgumentError => e
    handle_error(e, 'Invalid comment parameters', :bad_request)
  end

  def destroy
    if @comment.destroy
      @message = 'Comment deleted successfully'
      render 'shared/response', status: :ok
    else
      @ok = false
      @message = 'Failed to delete comment'
      render 'shared/response', status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound => e
    handle_error(e, 'Post not found', :not_found)
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    handle_error(e, 'Comment not found', :not_found)
  end

  def comment_params
    params.require(:comment).permit(:body)
  rescue ActionController::ParameterMissing => e
    handle_error(e, 'Comment parameters are missing', :bad_request)
  end

  def handle_error(error, message, status)
    unless performed?
      @ok = false
      @message = message
      @details = [error.message]
      render 'shared/response', status: status
    end
  end
end
