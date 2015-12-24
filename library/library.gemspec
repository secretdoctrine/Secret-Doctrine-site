$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "library/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "library"
  s.version     = Library::VERSION
  s.authors     = ["yavnodm@gmail.com"]
  s.email       = ["yavnodm@gmail.com"]
  #s.homepage    = "local"
  s.summary     = "library for secret-doctrine"
  s.description = "searchable library"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "sqlite3"
end
