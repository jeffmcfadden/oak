require_dependency "oak/application_controller"
require 'xmlrpc/server'

module Oak
  class MetaWeblogApi::BaseController < ApplicationController
    
    protect_from_forgery with: :null_session
    
    before_action :setup_xmlrpc_server
    
    # before_action :authenticate_request
    
    def index
      Rails.logger.info "MetaWeblogApi#Base"
      Rails.logger.info "  Raw Post:"
      Rails.logger.info request.raw_post
      
      response = @xmlrpc_server.process(request.raw_post)
      
      Rails.logger.info "  Responding With:"
      Rails.logger.info response
      
      
      render xml: response
      #
      # rpc = parse_xml_rpc_call(request.raw_post)
      # Rails.logger.info rpc
      #
      #
      #
      # if rpc[:method] == "system.listMethods"
      #
      #   methods_response = {"params"=>{"param"=>{"value"=>{"array"=>{"data"=>{"value"=>[{"string"=>"metaWeblog.getUsersBlogs"}, {"string"=>"metaWeblog.setTemplate"}, {"string"=>"metaWeblog.getTemplate"}, {"string"=>"metaWeblog.deletePost"}, {"string"=>"metaWeblog.newMediaObject"}, {"string"=>"metaWeblog.getCategories"}, {"string"=>"metaWeblog.getRecentPosts"}, {"string"=>"metaWeblog.getPost"}, {"string"=>"metaWeblog.editPost"}, {"string"=>"metaWeblog.newPost"}]}}}}}}
      #
      #   render :xml => methods_response.to_xml( root: "methodResponse" )
      #
      # elsif rpc[:method] == "wp.getUsersBlogs"
      #
      #
      #
      # end
      #
    end
    
    private
    
      def setup_xmlrpc_server
        @xmlrpc_server = XMLRPC::BasicServer.new
        
        @xmlrpc_server.add_handler( "wp.getUsersBlogs" ) do |user,pass|
          authenticate(user,pass)
          wp_getUsersBlogs
        end
        
        @xmlrpc_server.add_handler( "wp.getProfile" ) do |blog_id,user,pass,fields = []|
          authenticate(user,pass)
          wp_getProfile(blog_id,fields)
        end

        @xmlrpc_server.add_handler( "wp.getPosts" ) do |blog_id,user,pass,filter = {},fields = []|
          authenticate(user,pass)
          wp_getPosts(blog_id,filter,fields)
        end
        
        @xmlrpc_server.add_handler( "wp.getPosts" ) do |user,pass,post_id,fields = []|
          authenticate(user,pass)
          wp_getPost(post_id,fields)
        end
        
        
        @xmlrpc_server.add_introspection
      end
      
      def authenticate(user,password)
        @user = User.find_for_authentication(email: user)
        
        unless @user.present? && @user.valid_password?(password)
          raise "Unauthorized"
        end
      end
      
      # Limitation: Only returns a single blog right now. Multiple blogs are
      # not support with Oak yet.
      def wp_getUsersBlogs
        Rails.logger.debug "wp_getUsersBlogs"
        
        [
          {
            blogid:   "1",
            blogName: Oak::site_name, 
            url:      root_url, 
            xmlrpc:   xmlrpc_url, 
            isAdmin:  true
          }
        ]
      end
      
      def wp_getProfile(blog_id,fields)
        { 
          user_id:      "#{@user.id}",
          username:     "#{@user.email}",
          first_name:   "",
          last_name:    "",
          bio:          "",
          email:        "#{@user.email}",
          nickname:     "Admin",
          nicename:     "",
          url:          root_url,
          display_name: "Administrator"
        }
      end
      
      def wp_getPosts(blog_id,filter,fields)
        Post.all.order( published_at: :desc ).collect{ |p| p.fields_for_wordpress }
      end
      
      def wp_getPost(post_id,fields)
        Post.find(post_id).fields_for_wordpress
      end
      
    
  end
end