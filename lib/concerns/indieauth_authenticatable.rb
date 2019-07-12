module Oak
  module IndieauthAuthenticatable
    extend ActiveSupport::Concern
  
    included do
      protect_from_forgery with: :null_session
      before_action :authenticate_request
    end
  
    private
  
      def authenticate_request
        token = nil
        token ||= request.headers[:authorization].gsub( 'Bearer', '' ).strip if request.headers[:authorization].present?
        token ||= params[:access_token] if params[:access_token].present?
      
        @authenticated_user = nil
        if token.present?          
          @authorization_request = IndieauthAuthorizationRequest.find_by access_token: token, approved: true
          @authenticated_user    = User.find_by( id: @authorization_request.user_id )
        else
          Rails.logger.debug "No authentication token was provided."
        end
      
        if @authenticated_user.nil?
          Rails.logger.error "Authentication failed. Invalid access token."
          render json: { error: "unauthorized", error_description: "Invalid access token." }, status: 401
          return
        end
      end
  end
end