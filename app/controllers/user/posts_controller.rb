class User::PostsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def index
       @posts = current_user.posts
    end

    def edit; end

    def update
        if @post.update(post_params)
        flash[:notice] = 'Post updated successfully'
        redirect_to user_posts_path
      else
        flash.now[:alert] = 'Post update failed'
        render :edit, status: :unprocessable_entity
       end
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :address)
    end
    
end
