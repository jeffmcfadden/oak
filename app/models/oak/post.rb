module Oak
  class Post < ApplicationRecord
    belongs_to :author, class_name: Oak.author_class.to_s, optional: true
    has_many :outgoing_webmentions
    
    before_validation :set_author

    extend FriendlyId
    friendly_id :title, use: :slugged
    
    acts_as_taggable
    
    scope :live, -> { where( live: true ) }
    
    validates :published_at, presence: true
    
    before_validation :set_published_at_to_now_if_nil
    before_validation :auto_set_micro_tag
    
    def self.find_by_url( url )
      uri = URI( url )
      
      begin
        post_id = Rails.application.routes.recognize_path( uri.path )[:id]
        return Post.friendly.find( post_id )
      rescue StandardError => err
        puts Rails.application.routes.recognize_path( uri.path )
        return nil
      end
    end
    
    def draft?
      !live
    end
    
    def body_html
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown.render body_with_asset_urls
    end
    
    def body_with_asset_urls
      matches = body.scan( /\{\% asset_path "(.*?)" \%\}/ )
      body_with_asset_urls = body
      
      matches.each do |m|
        body_with_asset_urls = body_with_asset_urls.gsub( "{% asset_path \"#{m[0]}\" %}", ActionController::Base.helpers.asset_path(m[0]) )
      end
      
      body_with_asset_urls
    end
    
    def send_webmentions
      urls = URI.extract( body_html, ["http", "https"] )
      
      urls.uniq.each do |url|
        OutgoingWebmention.validate_and_send( target_url: url, post: self )
      end
    end
    
    # string   post_id
    # string   post_title1
    # datetime post_date1
    # datetime post_date_gmt1
    # datetime post_modified1
    # datetime post_modified_gmt1
    # string   post_status1
    # string   post_type1
    # string   post_format1
    # string   post_name1
    # string   post_author1 author id
    # string   post_password1
    # string   post_excerpt1
    # string   post_content1
    # string   post_parent1
    # string   post_mime_type1
    # string   link1
    # string   guid1
    # int      menu_order1
    # string   comment_status1
    # string   ping_status1
    # bool     sticky1
    # struct   post_thumbnail1: See wp.getMediaItem.
    # array    terms
    # struct:  See wp.getTerm
    # array    custom_fields
    # struct   enclosure
    
    def fields_for_wordpress
      {
        post_id: "#{id}"
        post_title: "#{title}"
        post_date: "#{published_at}"
        post_date_gmt: "#{published_at.utc}"
        post_modified: "#{updated_at}"
        post_modified_gmt: "#{updated_at.utc}"
        post_status: "#{live? ? : "publish" : "draft"}"
        post_type: "post"
        post_format: ""
        post_name: "#{slug}"
        post_author: "1"
        post_password: ""
        post_excerpt: ""
        post_content: "#{body_html}"
        post_parent: "0"
        post_mime_type: "text/html"
        link: ""
        guid: ""
        menu_order: ""
        comment_status: ""
        ping_status: ""
        sticky: ""
        post_thumbnail: {}
        terms: []
        custom_fields: []
        enclosure: {}
      }
    end
    
    private
      def set_author
        Rails.logger.debug "Post#set_author"
        
        self.author = (Oak.author_class.find_by(id: author_id.to_i) rescue nil)
      end
      
      def set_published_at_to_now_if_nil
        self.published_at = Time.now if self.published_at.nil?
      end
    
      def auto_set_micro_tag
        if title.blank? && body.length <= 280
          self.tag_list += ", micro"
        end
      end
    
  end
end