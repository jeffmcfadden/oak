require_dependency "oak/application_controller"

module Oak
  class PostsController < ApplicationController
    
    layout '/application'
    
    def index
      @posts = Post.live.order( published_at: :desc ).page(params[:page]).per(params[:per])
    end
    
    def show
      @post = Post.live.friendly.find( params[:id] )
    end
    
  end
end
