require "oak/engine"

module Oak
  # Your code goes here...
  
  mattr_accessor :author_class
  
  def self.author_class
    @@author_class.constantize
  end
  
end
