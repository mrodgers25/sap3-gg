# frozen_string_literal: true

module Admin
  class CommentsController < Admin::BaseAdminController
    def create
      @comment = Comment.create(comment_params)
      if @comment.save
        flash[:notice] = 'Comment Saved'
      else
        flash[:info] = @comment.errors.full_messages
      end
      redirect_location = "admin_#{@comment.reference}s_path(#{@comment.reference_id})"
      redirect_back(fallback_location: redirect_location)
    end

    def update
      @comment = Comment.find(params[:id])
    end

    def destroy
      @comment = Comment.find(params[:id])
      @comment.destroy
    end

    private

    def comment_params
      params.require(:comment).permit!
    end
  end
end
