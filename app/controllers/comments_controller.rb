class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user!

  def index
    @comments = @post.comments
    render :index
  end

  def show
    render :show
  end

  def create
    @comment = @post.comments.build(comment_params.merge(user: current_user))
    if @comment.save
      render :create, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render :update, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    render :destroy, status: :ok
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
