class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @comments = @post.comments
    @data = @comments
    @message = 'Comments retrieved successfully'
    render 'shared/response', status: :ok
  end

  def show
    @data = @comment
    @message = 'Comment retrieved successfully'
    render 'shared/response', status: :ok
  end

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      @data = @comment.slice(:id, :body, :created_at, :updated_at)
      @message = 'Comment created successfully'
      render 'shared/response', status: :created
    else
      @ok = false
      @message = 'Failed to create comment'
      @details = @comment.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      @data = @comment.slice(:id, :body, :created_at, :updated_at)
      @message = 'Comment updated successfully'
      render 'shared/response', status: :ok
    else
      @ok = false
      @message = 'Failed to update comment'
      @details = @comment.errors.full_messages
      render 'shared/response', status: :unprocessable_entity
    end
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
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
