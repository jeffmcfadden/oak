require_dependency "oak/application_controller"

module Oak
  class PostsController < ApplicationController
    
    layout '/application'
    
    def index
      if Oak.tags_to_exclude_from_home_page.empty?
        @posts = Post.live.order( published_at: :desc ).page(params[:page]).per(Oak.posts_per_page)
      else
        @posts = Post.tagged_with(Oak.tags_to_exclude_from_home_page, :exclude => true).live.order( published_at: :desc ).page(params[:page]).per(Oak.posts_per_page)
      end
    end
    
    def show
      @post = Post.live.friendly.find( params[:id] )
    end
    
  end
end