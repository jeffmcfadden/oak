require_dependency "oak/application_controller"

module Oak
  class Admin::WebmentionsController < Admin::ApplicationController
  
    
  
    def index
      @webmentions = IncomingWebmention.all.order( created_at: :desc ).page( params[:page] )
    end
    
    def show
      @webmention = IncomingWebmention.find params[:id]
    end
    
    def destroy
      @webmention = IncomingWebmention.find params[:id]
      @webmention.destroy
      
      redirect_to [:admin, :webmentions]
    end
  
  end
end
