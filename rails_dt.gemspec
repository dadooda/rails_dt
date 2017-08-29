
require_relative "lib/rails_dt/version"

Gem::Specification.new do |s|
  s.name = "rails_dt"
  s.version = RailsDt::VERSION
  s.authors = ["Alex Fortuna"]
  s.email = ["fortunadze@gmail.com"]
  s.homepage = "http://github.com/dadooda/rails_dt"

  s.summary = %q{Ruby/Rails debug toolkit}
  #s.description = s.summary    # OPTIMIZE: Do we need this?

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f)}
  s.require_paths = ["lib"]
end
