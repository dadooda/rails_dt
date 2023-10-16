
require_relative "lib/dy/version"

# TODO: Dependencies! `attr_magic` and stuff.

Gem::Specification.new do |s|
  s.name = "rails_dt"
  s.version = DY::VERSION
  s.authors = ["Alex Fortuna"]
  s.email = ["fortunadze@gmail.com"]
  s.homepage = "http://github.com/dadooda/rails_dt"

  s.summary = "Ruby/Rails debug toolkit"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
