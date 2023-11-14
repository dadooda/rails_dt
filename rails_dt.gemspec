
require_relative "lib/dy/version"

Gem::Specification.new do |s|
  s.name = "rails_dt"
  s.summary = "Ruby/Rails debug toolkit"
  s.version = DY::VERSION

  s.authors = ["Alex Fortuna"]
  s.email = ["fortunadze@gmail.com"]
  s.homepage = "http://github.com/dadooda/rails_dt"
  s.license = "MIT"

  s.files = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")

  # OPTIMIZE: This should work on its own one day. Remove this when it does.
  s.add_dependency "attr_magic", "~> 0.1.0"

  s.add_development_dependency "rspec_magic", "~> 0.1.0"
end
