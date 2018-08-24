require_dependency "oak/application_controller"

module Oak
  class Admin::PostAssetsController < ApplicationController
    
    def create
      @post_asset = PostAsset.create post_asset_params
    end
    
    private
    
      def post_asset_params
        params.require( :post_asset ).permit( :file )
      end
    
  end
end
