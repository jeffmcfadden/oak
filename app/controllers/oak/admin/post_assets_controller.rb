require_dependency "oak/application_controller"

module Oak
  class Admin::PostAssetsController < ApplicationController
    
    def index
      @post_assets = PostAsset.all.order( created_at: :desc ).page( params[:page] )
    end
    
    def create
      @post_asset = PostAsset.create post_asset_params
    end
    
    def destroy
      @post_asset = PostAsset.find params[:id]
      @post_asset.destroy
      
      redirect_to [:admin, :post_assets]
    end
    
    
    private
    
      def post_asset_params
        params.require( :post_asset ).permit( :file )
      end
    
  end
end
