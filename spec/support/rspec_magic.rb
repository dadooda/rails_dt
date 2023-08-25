
require_relative "../../libx/rspec_magic"
require_relative "../../libx/rspec_magic/stable"
require_relative "../../libx/rspec_magic/unstable"

# TODO: Fin.
# module RSpecMagic::Unstable::IncludeDirContext::Config
#   def self.spec_root_path
#     File.expand_path("..", __dir__)
#   end
# end

RSpecMagic::Config.spec_path = File.expand_path("..", __dir__)
