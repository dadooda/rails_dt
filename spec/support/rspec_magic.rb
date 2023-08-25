
require_relative "../../libx/rspec_magic"
require_relative "../../libx/rspec_magic/stable"
require_relative "../../libx/rspec_magic/unstable"

RSpecMagic::Config.spec_path = File.expand_path("..", __dir__)
