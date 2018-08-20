require_dependency "oak/application_controller"

module Oak
  class PostsController < ApplicationController
    
    def index
      @posts = Post.live.order( published_at: :desc ).page(params[:page]).per(params[:per])
    end
    
    def show
    end
    
  end
end
