require 'uri'
require_dependency "oak/application_controller"

module Oak
  class Indieauth::IndieauthController < ApplicationController
    
    def indiauth_post
      if params[:code].present? && params[:client_id].present? && params[:redirect_uri].present?
        authentication_request = IndieauthAuthenticationRequest.find_by code: params[:code], client_id: params[:client_id], redirect_uri: params[:redirect_uri]
        
        if authentication_request.present?
          render json: { me: request.base_url }
          return
        end
      end      
      
      render json: { error: "invalid_request" }, status: 400
    end
    
    def indiauth_get
      if params[:response_type].blank? || params[:response_type] == "id"
        store_authentication_request_to_session

        if current_user.present?
          redirect_to indieauth_show_authentication_request_path
        else
          store_location_for(:user, indieauth_show_authentication_request)
          redirect_to new_user_session_path
        end
      elsif params[:response_type] == "code"
        store_authorization_request_to_session
        
        if current_user.present?
          redirect_to indieauth_show_authorization_request_path
        else
          store_location_for(:user, indieauth_show_authorization_request_path)
          redirect_to new_user_session_path
        end
      end      
    end
    
    def request_token
      if params[:grant_type] == "authorization_code"
        authentication_request = IndieauthAuthorizationRequest.find_by code: params[:code], client_id: params[:client_id], redirect_uri: params[:redirect_uri], me: params[:me]
        
        if authentication_request.present?
          render json: { access_token: authentication_request.access_token, token_type: "Bearer", scope: authentication_request.scope, me: authentication_request.me }, status: 200
          return
        end
      end

      render json: { error: "invalid_request" }, status: 400
    end
    
    def verify_token
      authentication_request = IndieauthAuthorizationRequest.find_by access_token: request.headers[:authorization].gsub( 'Bearer', '' )
        
      if authentication_request.present?
        render json: { client_id: authentication_request.client_id, scope: authentication_request.scope, me: authentication_request.me }, status: 200
        return
      end

      render json: { error: "invalid_request" }, status: 400
    end
    
    
    def show_authentication_request
      authenticate_user!
    end
    
    def show_authorization_request
      authenticate_user!
    end
    
    def authorize_authentication_request
      
      authentication_request = IndieauthAuthenticationRequest.create state: session[:authentication_request_state],
      redirect_uri: session[:authentication_request_redirect_uri],
      client_id:    session[:authentication_request_client_id],
      me:           session[:authentication_request_me],
      code:         (0...8).map { (65 + rand(26)).chr }.join,
      approved:     true
      
      uri = URI.parse(session[:authentication_request_redirect_uri])
      new_query_ar = URI.decode_www_form(uri.query || '') << ["state", authentication_request.state, "code", authentication_request.code]
      uri.query = URI.encode_www_form(new_query_ar)
            
      redirect_to uri.to_s
    end
    
    def authorize_authorization_request
      
      authentication_request = IndieauthAuthorizationRequest.create state: session[:authentication_request_state],
      redirect_uri: session[:authentication_request_redirect_uri],
      client_id:    session[:authentication_request_client_id],
      me:           session[:authentication_request_me],
      scope:        session[:authorization_request_scope],
      code:         (0...8).map { (65 + rand(26)).chr }.join,
      access_token: (0...16).map { (65 + rand(26)).chr }.join,
      approved:     true
      
      uri = URI.parse(session[:authentication_request_redirect_uri])
      new_query_ar = URI.decode_www_form(uri.query || '') << ["state", authentication_request.state, "code", authentication_request.code]
      uri.query = URI.encode_www_form(new_query_ar)
            
      redirect_to uri.to_s
    end
    
    
    def store_authentication_request_to_session
      session[:authentication_request_state]        = params[:state]
      session[:authentication_request_state_set_at] = Time.now
      session[:authentication_request_redirect_uri] = params[:redirect_uri]
      session[:authentication_request_client_id]    = params[:client_id]
      session[:authentication_request_me]           = params[:me]
    end  
    
    def store_authorization_request_to_session
      session[:authorization_request_state]        = params[:state]
      session[:authorization_request_state_set_at] = Time.now
      session[:authorization_request_redirect_uri] = params[:redirect_uri]
      session[:authorization_request_client_id]    = params[:client_id]
      session[:authorization_request_me]           = params[:me]
      session[:authorization_request_scope]        = params[:scope]
    end  
    
    
    
  end
end
