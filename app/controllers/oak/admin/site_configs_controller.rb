require_dependency "oak/application_controller"

module Oak
  class Admin::SiteConfigsController < Admin::ApplicationController
    
    def index
      @site_configs = SiteConfig.all.order( key: :asc )
    end
    
    def new
      @site_config = SiteConfig.new
    end
    
    def create
      @site_config = SiteConfig.find_or_create_by key: params[:site_config][:key]
      @site_config.update value: params[:site_config][:value]
      
      redirect_to [:admin, :site_configs]
    end
    
    def edit
      @site_config = SiteConfig.find params[:id]
    end
    
    def update
      @site_config = SiteConfig.find_or_create_by key: params[:site_config][:key]
      @site_config.update value: params[:site_config][:value]
      
      redirect_to [:admin, :site_configs]
    end
    
    def destroy
      @site_config = SiteConfig.find params[:id]
      @site_config.destroy
      
      redirect_to [:admin, :site_configs]
    end
    
  end
end
