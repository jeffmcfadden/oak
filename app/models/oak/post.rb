module Oak
  class Post < ApplicationRecord
    belongs_to :author, class_name: Oak.author_class.to_s, optional: true
    before_validation :set_author

    extend FriendlyId
    friendly_id :title, use: :slugged
    
    scope :live, -> { where( live: true ) }
    
    def body_html
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown.render body
    end
    
    private
      def set_author
        self.author = Oak.author_class.find_by(id: author_id.to_i)
      end
    
  end
end