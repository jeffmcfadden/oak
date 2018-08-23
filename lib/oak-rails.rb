require "oak/engine"

module Oak
  # Your code goes here...
  
  mattr_accessor :author_class
  
  mattr_accessor :site_name
  mattr_accessor :site_description
  
  @@site_name        = ""
  @@site_description = ""
  
  def self.author_class
    @@author_class.constantize
  end
  
  def self.configure
    yield self
  end
  
end
