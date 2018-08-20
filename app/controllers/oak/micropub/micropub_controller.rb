require_dependency "oak/application_controller"

module Oak
  class Micropub::MicropubController < ApplicationController
    
    protect_from_forgery with: :null_session
    before_action :authenticate_request
    
    def micropub_post
      if params[:h] == "entry"
        
        @post = Post.new
        @post.title        = params[:name]
        @post.body         = params[:content]
        @post.live         = true
        @post.published_at = params[:published]
        
        if @post.valid?
          @post.save
          render plain: 'Post Created', location: @post, status: 201
        else
          Rails.logger.error "Post did not validate."
          render json: { error: "invalid_request", error_description: "#{@post.errors.full_messages.join(', ')}" }, status: 400
          return
        end
      else
        Rails.logger.error "Unrecognized request type."
        render json: { error: "invalid_request", error_description: "Unrecognized request type. No h_entry found." }, status: 400
        return
      end
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
          render json: { error: "unauthorized", error_description: "Invalid access token." }, status: 401
          return
        end
      end
    
  end
end
