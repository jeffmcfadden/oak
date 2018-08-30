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
    
    private
      def set_author
        self.author = Oak.author_class.find_by(id: author_id.to_i)
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