require "net/https"
require "uri"

module Oak
  class OutgoingWebmention < ApplicationRecord
    belongs_to :post
    
    validates :target_url, presence: true
    
    def self.validate_and_send( target_url: nil, post: nil )
      return unless post.present? && target_url.present?
      
      webmention = OutgoingWebmention.new post: post, target_url: target_url
      endpoint   = webmention.discover_endpoint
      
      if endpoint.present?
        
        uri = URI.parse(endpoint)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        
        req = Net::HTTP::Post.new(uri.request_uri)
        req.set_form_data( { source: Oak::Engine.routes.url_helpers.post_url( post, host: Rails.application.routes.default_url_options[:host] ), target: target_url } )
        response = http.request(req)
        
        # puts "Response:"
        # puts response.body
        # puts response.code

        webmention.sent_at = Time.now
        webmention.save
      else
        Rails.logger.info "No endpoint found for target_url: #{target_url}"
      end
    end
    
    def discover_endpoint
      uri = URI.parse(target_url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      
      response.header.each_header{ |key,value|
        endpoint = endpoint_from_headers(value)
        if endpoint.present?
          return endpoint.strip
        end
      }
      
      return endpoint_from_body( response.body )
    end
    
    
    # https://github.com/indieweb/webmention-client-ruby/
    def endpoint_from_body(html)
      doc = Nokogiri::HTML(html)

      if !doc.css('[rel~="webmention"]').css('[href]').empty?
        doc.css('[rel~="webmention"]').css('[href]').attribute('href').value
      elsif !doc.css('[rel="http://webmention.org/"]').css('[href]').empty?
        doc.css('[rel="http://webmention.org/"]').css('[href]').attribute('href').value
      elsif !doc.css('[rel="http://webmention.org"]').css('[href]').empty?
        doc.css('[rel="http://webmention.org"]').css('[href]').attribute('href').value
      end
    end

    # https://github.com/indieweb/webmention-client-ruby/
    def endpoint_from_headers(header)
      return unless header

      if (matches = header.match(/<([^>]+)>; rel="[^"]*\s?webmention\s?[^"]*"/))
        return matches[1]
      elsif (matches = header.match(/<([^>]+)>; rel=webmention/))
        return matches[1]
      elsif (matches = header.match(/rel="[^"]*\s?webmention\s?[^"]*"; <([^>]+)>/))
        return matches[1]
      elsif (matches = header.match(/rel=webmention; <([^>]+)>/))
        return matches[1]
      elsif (matches = header.match(%r{<([^>]+)>; rel="http://webmention\.org/?"}))
        return matches[1]
      elsif (matches = header.match(%r{rel="http://webmention\.org/?"; <([^>]+)>}))
        return matches[1]
      end
    end
    
  end
end
