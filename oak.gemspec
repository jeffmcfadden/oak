$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "oak/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "oak"
  s.version     = Oak::VERSION
  s.authors     = ["Jeff McFadden"]
  s.email       = ["jeff@mcfadden.io"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Oak."
  s.description = "TODO: Description of Oak."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.2.1"

  s.add_development_dependency "sqlite3"
end
