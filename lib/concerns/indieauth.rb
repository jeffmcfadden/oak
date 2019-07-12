module Indieauth
  extend ActiveSupport::Concern
  
  included do
    protect_from_forgery with: :null_session
  end
  
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
  
  def indieauth_get
    if params[:response_type].blank? || params[:response_type] == "id"
      create_authentication_request

      if current_user.present?
        redirect_to indieauth_show_authentication_request_path(@authentication_request)
        return
      else
        store_location_for(:user, indieauth_show_authentication_request_path(@authentication_request))
        redirect_to indieauth_show_authentication_request_path(@authentication_request)
        return
      end
    elsif params[:response_type] == "code"
      create_authorization_request
      
      if current_user.present?
        redirect_to indieauth_show_authorization_request_path(@authorization_request)
        return
      else
        store_location_for(:user, indieauth_show_authorization_request_path(@authorization_request))
        redirect_to indieauth_show_authorization_request_path(@authorization_request)
        return
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
    
    @authentication_request = IndieauthAuthenticationRequest.find_by id: params[:id], user_id: nil, approved: false
  end
  
  def show_authorization_request
    authenticate_user!
    
    @authorization_request = IndieauthAuthorizationRequest.find_by id: params[:id], user_id: nil, approved: false
  end
  
  def authorize_authentication_request
    @authentication_request = IndieauthAuthenticationRequest.find_by id: params[:id], user_id: nil, approved: false
    @authentication_request.update user_id: current_user.id, approved: true
    
    uri = URI.parse(@authentication_request.redirect_uri)
    new_query_ar = URI.decode_www_form(uri.query || '') << ["state", @authentication_request.state]
    new_query_ar = new_query_ar << ["code",  @authentication_request.code]
    new_query_ar = new_query_ar << ["me",  @authorization_request.me]
    uri.query = URI.encode_www_form(new_query_ar)
          
    redirect_to uri.to_s
  end
  
  def authorize_authorization_request
    @authorization_request = IndieauthAuthorizationRequest.find_by id: params[:id], user_id: nil, approved: false
    @authorization_request.update user_id: current_user.id, approved: true
    
    uri = URI.parse(@authorization_request.redirect_uri)
    new_query_ar = URI.decode_www_form(uri.query || '') << ["state", @authorization_request.state]
    new_query_ar = new_query_ar << ["code",  @authorization_request.code]
    new_query_ar = new_query_ar << ["me",  @authorization_request.me]
    
    uri.query = URI.encode_www_form(new_query_ar)
          
    redirect_to uri.to_s
  end
  
  
  def create_authentication_request
    @authentication_request = IndieauthAuthenticationRequest.create state:        params[:state],
      redirect_uri: params[:redirect_uri],
      client_id:    params[:client_id],
      me:           params[:me],
      code:         (0...8).map { (65 + rand(26)).chr }.join,
      approved:     false
  end  
  
  def create_authorization_request
    @authorization_request = IndieauthAuthorizationRequest.create state:        params[:state],
      redirect_uri: params[:redirect_uri],
      client_id:    params[:client_id],
      me:           params[:me],
      code:         (0...8).map { (65 + rand(26)).chr }.join,
      access_token: (0...16).map { (65 + rand(26)).chr }.join,
      approved:     false,
      scope:        params[:scope]
  end  
end