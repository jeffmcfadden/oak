require_dependency "oak/application_controller"

module Oak
  class WebmentionsController < ApplicationController
    protect_from_forgery with: :null_session
    
    # https://www.w3.org/TR/webmention/#receiving-webmentions-p-1
    # The spec suggest that we do all sorts of things with an incoming webmention, but for now
    # we're playing it super safe: We don't trust any incoming request. We create an webmention
    # if it passes the basic validation, and we let Admins decide what to do with it, and when
    # to even try to process it. This way we can't actually be part of a DDoS attack, among
    # other benefits
    def create
      webmention = IncomingWebmention.new source_url: params[:source], target_url: params[:target], ip_address: request.remote_ip
      
      if webmention.valid?
        webmention.save
      else
        Rails.logger.info "Invalid webmention: #{webmention.errors.full_messages}" 
      end
      
      render plain: "OK", status: 202
    end
    
  end
end
