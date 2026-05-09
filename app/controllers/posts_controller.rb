class PostsController < ApplicationController
  def index
    @posts = logged_in? ? Post.recent : Post.published.recent
  end

  def show
    @post = Post.find(params[:id])
    redirect_to root_path unless @post.published? || logged_in?
  end
end
