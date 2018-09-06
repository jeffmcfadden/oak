require_dependency "oak/application_controller"

module Oak
  class Micropub::MicropubController < ApplicationController
    
    protect_from_forgery with: :null_session
    before_action :authenticate_request
    
    def micropub_post
      if params[:h] == "entry"
        build_post_from_form
        save_post_and_return
      elsif params[:type].class == Array && params[:type].first == "h-entry"
        build_post_from_json
        save_post_and_return
      elsif params[:action] == "update"
        update_post_and_return
      else
        Rails.logger.error "Unrecognized request type."
        render json: { error: "invalid_request", error_description: "Unrecognized request type. No h_entry found." }, status: 400
        return
      end
    end
    
    def build_post_from_form
      @post = Post.new
      @post.title        = params[:name]
      @post.live         = true
      @post.published_at = params[:published]
      
      if params[:category].present? && params[:category].class == Array
        @post.tag_list = params[:category].join( "," )
      elsif params[:category].present? && params[:category].class == String
        @post.tag_list = params[:category]
      end      
      
      content = params[:content]
      
      if params[:photo].present?
        content += "\n\n"
        content += "<img src=\"#{params[:photo]}\" />\n"
      end
      
      @post.body         = content
    end
    
    def build_post_from_json
      properties = params[:properties]
      
      @post = Post.new
      @post.title        = params[:name]&.first
      
      if properties[:html].present? && properties[:content].empty?
        content         = properties[:html].first
      else
        content = properties[:content].first
        
        # The weird h-entry format with html in the content element.
        if content.class == Hash && content[:html].present?
          content = content[:html]
        end
        
      end
      
      if properties[:photo].present? && properties[:photo].class == Array
        content += "\n\n"
        properties[:photo].each do |p|
          if p.class == String
            content += "<img src=\"#{p}\" />\n"
          elsif p.class == Hash
            src = p[:value]
            alt = p[:alt]
            
            content += "<img src=\"#{src}\" alt=\"#{alt}\" />\n"
          end
        end
      end
      
      @post.body = content
      
      @post.live         = true
      @post.published_at = params[:published]&.first
      
      
      if properties[:category].present? && properties[:category].class == Array
        @post.tag_list = properties[:category].join( "," )
      end
    end
    
    def save_post_and_return
      if @post.valid?
        @post.save
        render plain: 'Post Created', location: @post, status: 201
      else
        Rails.logger.error "Post did not validate."
        render json: { error: "invalid_request", error_description: "#{@post.errors.full_messages.join(', ')}" }, status: 400
        return
      end
    end
    
    def micropub_get
      if params[:q] == "config"
        render json: { "media-endpoint" => micropub_media_url }
      else
        render plain: ""
      end
    end
    
    def media
      @post_asset = PostAsset.create file: params[:file]
      response.set_header 'Location', @post_asset.public_url

      render plain: "Location: #{@post_asset.public_url}", status: 201
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
        end
        
        if @authenticated_user.nil?
          Rails.logger.error "Authentication failed. Invalid access token."
          render json: { error: "unauthorized", error_description: "Invalid access token." }, status: 401
          return
        end
      end
    
  end
end
