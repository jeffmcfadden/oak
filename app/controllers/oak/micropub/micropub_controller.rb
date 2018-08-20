require_dependency "oak/application_controller"

module Oak
  class Micropub::MicropubController < ApplicationController
    
    before_action :authenticate_request
    
    def micropub_post
    end
    
    def micropub_get
    end
    
    private
    
      def authenticate_request
        token = nil
        token ||= request.headers[:authorization].gsub( 'Bearer', '' ).strip if request.headers[:authorization].present?
        token ||= params[:access_token] if params[:access_token].present?
        
        @authenticated_user = nil
        if token.present?
          @authenticated_user = User.find_by( access_token: token )
        end
        
        if @authenticated_user.nil?
          Rails.logger.error "Authentication failed. Invalid access token."
          render json: { error: "Authentication failed.", error_description: "Invalid access token." }, status: 401
          return
        end
      end
    
  end
end
