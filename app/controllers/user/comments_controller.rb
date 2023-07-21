class User::CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_comment, only: [:edit, :update]

    def index
       @comments = current_user.comments
    end

    def edit; end

    def update
        if @comment.update(post_params)
        flash[:notice] = 'comment updated successfully'
        redirect_to user_comments_path
      else
        flash.now[:alert] = 'Post update failed'
        render :edit, status: :unprocessable_entity
       end
    end

    private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def post_params
      params.require(:comment).permit(:content)
    end
end
