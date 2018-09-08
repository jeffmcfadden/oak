require 'friendly_id'
require 'acts-as-taggable-on'
require 'kaminari'

module Oak
  class Engine < ::Rails::Engine
    isolate_namespace Oak
  end
end