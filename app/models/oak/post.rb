module Oak
  class Post < ApplicationRecord
    belongs_to :author, class_name: Oak.author_class.to_s
    
    before_validation :set_author
    
    private
      def set_author
        self.author = Oak.author_class.find_by(id: author_id.to_i)
      end
    
  end
end
