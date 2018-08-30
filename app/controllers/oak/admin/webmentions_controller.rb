require_dependency "oak/application_controller"

module Oak
  class Admin::WebmentionsController < ApplicationController
  
    def index
      @webmentions = IncomingWebmentions.all.order( created_at: :desc )
    end
    
    def show
      @webmention = Webmention.find params[:id]
    end
    
    def destroy
      @webmention = Webmention.find params[:id]
      @webmention.destroy
      
      redirect_to [:admin, :webmentions]
    end
  
  end
end
