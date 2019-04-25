$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "oak/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "oak-rails"
  s.version     = Oak::VERSION
  s.authors     = ["Jeff McFadden"]
  s.email       = ["jeff@mcfadden.io"]
  s.homepage    = "https://github.com/jeffmcfadden/oak-rails"
  s.summary     = "Rails blogging engine."
  s.description = "Rails blogging engine. Provides nice things."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
 
  s.add_dependency "rails",               "~> 5.2.2.1"
  s.add_dependency "haml",                ">= 5.0.0"
  s.add_dependency "friendly_id",         ">= 5.2.0"
  s.add_dependency "kaminari",            ">= 1.1.1"
  s.add_dependency 'devise',              ">= 4.6.0"
  s.add_dependency 'redcarpet',           ">= 3.4.0"
  s.add_dependency 'acts-as-taggable-on', '~> 6.0'
  
  s.add_dependency 'nokogiri',            '>= 1.8.5'
  s.add_dependency 'rack',                '>= 2.0.6'
  s.add_dependency 'loofah',              '>= 2.2.3'
  
  # Right now we're making some (bad) assumptions about active storage
  s.add_dependency 'aws-sdk-s3',          '>= 1.17.0'
  
  s.add_development_dependency 'sqlite3'
end