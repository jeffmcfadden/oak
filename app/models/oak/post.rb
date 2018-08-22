module Oak
  class Post < ApplicationRecord
    belongs_to :author, class_name: Oak.author_class.to_s, optional: true
    before_validation :set_author

    extend FriendlyId
    friendly_id :title, use: :slugged
    
    acts_as_taggable
    
    scope :live, -> { where( live: true ) }
    
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
    
    private
      def set_author
        self.author = Oak.author_class.find_by(id: author_id.to_i)
      end
    
  end
end