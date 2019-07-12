require 'concerns/micropub'
require 'concerns/indieauth'
require 'concerns/indieauth_authenticatable'

module Oak
  # Your code goes here...
  def self.configure
    yield self
  end  
end