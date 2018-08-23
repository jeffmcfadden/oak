require "oak/engine"

module Oak
  # Your code goes here...
  
  mattr_accessor :author_class
  
  mattr_accessor :site_name
  mattr_accessor :site_description
  mattr_accessor :posts_per_page
  mattr_accessor :tags_to_exclude_from_home_page
  
  @@site_name        = ""
  @@site_description = ""
  
  @@posts_per_page   = 10
  @@tags_to_exclude_from_home_page = []
  
  def self.author_class
    @@author_class.constantize
  end
  
  def self.configure
    yield self
  end
  
end
