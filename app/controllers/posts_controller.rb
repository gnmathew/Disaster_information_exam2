class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.includes(:categories, :user).page(params[:page]).per(5).all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
    authorize @post, :edit?, policy_class: PostPolicy
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = 'Post created successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post create failed'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @post, :update?, policy_class: PostPolicy
    if @post.update(post_params)
      flash[:notice] = 'Post updated successfully'
      redirect_to posts_path
    else
      flash.now[:alert] = 'Post update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @post, :destroy?, policy_class: PostPolicy
    @post.destroy
    flash[:notice] = 'Post destroyed successfully'
    redirect_to posts_path
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :address, category_ids: [])
  end
end
