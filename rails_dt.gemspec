
# TODO: Finalize.
#require_relative ""
require File.expand_path("../lib/rails_dt/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "rails_dt"
  s.version = RailsDt::VERSION
  s.authors = ["Alex Fortuna"]
  s.email = ["fortunadze@gmail.com"]
  s.homepage = "http://github.com/dadooda/rails_dt"

  s.summary = "Ruby/Rails debug toolkit"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
