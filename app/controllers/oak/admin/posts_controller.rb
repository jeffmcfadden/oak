require_dependency "oak/application_controller"

module Oak
  class Admin::PostsController < Admin::ApplicationController
    
    def index
      @posts = Post.all.order( published_at: :desc, created_at: :desc )
    end
    
    def show
      set_post
    end
    
    def new
      @post = Post.new
    end
    
    def create
      @post = Post.create post_params
      
      redirect_to [:admin, :posts]
    end
    
    def edit
      set_post
    end
    
    def update
      set_post
      @post.update post_params
      
      redirect_to [:admin, :posts]
    end
    
    def destroy
      set_post
      
      @post.destroy
      
      redirect_to [:admin, :posts]
    end
    
    private
    
      def set_post
        @post = Post.friendly.find( params[:id] )
      end
    
      def post_params
        params.require( :post ).permit( :title, :body, :published_at, :author_id, :live, :tag_list )
      end
    
  end
end
