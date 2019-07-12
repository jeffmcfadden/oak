module MicropubController
  extend ActiveSupport::Concern
  
  def micropub_post
    Rails.logger.debug "MicropubController#micropub_post"
    
    if params[:h] == "entry"
      build_post_from_form
      save_post_and_return
    elsif params[:type].class == Array && params[:type].first == "h-entry"
      build_post_from_json
      save_post_and_return
    elsif request.POST[:action] == "update" || params[:action] == "update"
      update_post_and_return
    elsif request.POST[:action] == "delete" || params[:action] == "delete"
      delete_post_and_return
    else
      Rails.logger.error "Unrecognized request type."
      render json: { error: "invalid_request", error_description: "Unrecognized request type. No h_entry found." }, status: 400
      return
    end
  end
  
  def build_post_from_form
    Rails.logger.debug "  build_post_from_form"
    
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
      
      if params[:photo].class == String        
        content += "\n\n"
        content += "<img src=\"#{params[:photo]}\" />\n"
      elsif params[:photo].class == ActionDispatch::Http::UploadedFile
        @post_asset = PostAsset.create file: params[:photo]
        content += "\n\n"
        content += "<img src=\"#{@post_asset.public_url}\" />\n" 
      elsif params[:photo].class == Array
        params[:photo].each do |p|
          if p.class == ActionDispatch::Http::UploadedFile
            @post_asset = PostAsset.create file: p
            content += "\n\n"
            content += "<img src=\"#{@post_asset.public_url}\" />\n" 
          end
        end
      end
    end
    
    @post.body         = content
  end
  
  def build_post_from_json
    Rails.logger.debug "  build_post_from_json"
    
    properties = params[:properties]
    
    @post = Post.new
    @post.title        = params[:name]&.first

    content = content_from_json_params( params )
    
    if properties[:photo].present? && properties[:photo].class == Array
      Rails.logger.debug "    photo present, and is array"
      
      content += "\n\n"
      properties[:photo].each do |p|
        if p.class == String
          Rails.logger.debug "      this photo entry is a string"
          
          content += "<img src=\"#{p}\" />\n"
        elsif p.class == Hash || p.class == ActionController::Parameters
          Rails.logger.debug "      this photo entry is a hash/params"
          src = p[:value]
          alt = ERB::Util.html_escape(p[:alt])
          
          content += "<img src=\"#{src}\" alt=\"#{alt}\" />\n"
        else
          Rails.logger.debug "      this photo entry is something else (#{p.class})"
          
        end
      end
    else
      Rails.logger.debug "    did not find a photo"
    end
    
    @post.body = content
    
    @post.live         = true
    @post.published_at = params[:published]&.first
    
    
    if properties[:category].present? && properties[:category].class == Array
      @post.tag_list = properties[:category].join( "," )
    end
  end
  
  def update_post_and_return
    @post = Post.find_by_url( params[:url] )
    
    if @post.nil?
      render plain: 'Not found', status: 404
      return
    end
    
    if params[:replace].present?
      params[:replace].each do |k,v|
        if k.to_sym == :content
          if v.class == Array
            @post.body = v.first
          elsif v.class == Hash && v[:html].present?
            @post.body = v[:html]
          end
        elsif k.to_sym == :category
          @post.tag_list = v.join( ',' )
        end
      end
    end
    
    if params[:add].present?
      params[:add].each do |k,v|
        if k.to_sym == :category
          @post.tag_list.add(v)
        end
      end
    end
    
    if params[:delete].present?
      
      if params[:delete].class == Array
        params[:delete].each do |property|
          if property.to_sym == :category
            @post.tag_list = ""
          else
            Rails.logger.debug "Unsupported property removal: #{property}"
          end
        end
        
      elsif params[:delete].class == Hash || params[:delete].class == ActionController::Parameters
        
        params[:delete].each do |k,v|
          if k.to_sym == :category
            if v.class == Array
              v.each{ |t| @post.tag_list.remove t }
            end
          else
            Rails.logger.debug "Unsupported property removal: #{k}"
          end
        end
      else
        Rails.logger.debug "Delete is #{params[:delete].class}, an unsupported type."
      end
      
    end
    
    if @post.valid?
      @post.save
      render plain: 'Post updated', location: @post, status: 201
    else
      Rails.logger.error "Post did not validate."
      render json: { error: "invalid_request", error_description: "#{@post.errors.full_messages.join(', ')}" }, status: 400
      return
    end
    
  end
  
  def delete_post_and_return
    @post = Post.find_by_url( params[:url] )
    
    if @post.nil?
      render plain: 'Not found', status: 404
      return
    else
      @post.destroy
      render plain: 'Deleted', status: 200
      return
    end
  end
  
  def content_from_json_params( params )
    properties = params[:properties]
    
    properties = {} if properties.nil?

    content = ""
    
    if properties[:html].present? && properties[:content].empty?
      content         = properties[:html].first
    else
      content = properties[:content].first
      
      # The weird h-entry format with html in the content element.
      if (content[:html].present? rescue false)
        content = content[:html]
      end
      
    end
    
    content
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
  
end