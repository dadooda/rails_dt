# frozen_string_literal: true

"LODoc"

require_relative "../world/config"

module RSpecMagic; module Unstable
  # Include hierarchical contexts from <tt>spec/</tt> up to spec root.
  #
  #   describe Something do
  #     include_dir_context __dir__
  #     …
  #
  # OPTIMIZE: LODoc.
  module IncludeDirContext
    # TODO: Fin.
    # module Config
    #   # @param [String]
    #   def self.spec_root_path
    #     raise NotImplementedError, "Please define #{self}##{__method__} in your RSpec setup"
    #   end
    # end

    # OPTIMIZE: Retro-fix sibling features to use a dedicated module for exports.
    module Exports
      # TODO: Fin.
      def idc_probe
        p "hey, probe!"
        p "World::Config", World::Config
        # p "Config.root_path", Config.root_path
        # p "RSpec.spec_root", RSpec.spec_root
        # conf = RSpec.configure { |_| _ }
        # p "conf.methods", conf.methods.sort
        # p "conf.default_path", conf.default_path
      end

      def include_dir_context(dir)
        # TODO: Fin.
        # Compute root based on this file location.
        # spec_root = File.expand_path("../..", __dir__)

        d, steps = dir, []
        while d.size >= spec_root.size
          steps << d
          d = File.split(d).first
        end

        steps.reverse.each do |d|
          begin; include_context d; rescue ArgumentError; end
        end

        # TODO: Fin.
        # # A hack. We've got 2 sub-environments: plain and Rails, which share the same directory root.
        # # If we attempt to create 2 root contexts, RSpec will overwrite one with another.
        # # Hence we use distinct special names for root contexts and load them by hand.
        # begin; include_context "spec_top"; rescue ArgumentError; end
        # begin; include_context "rails_top"; rescue ArgumentError; end
      end
    end # Exports
  end # module

  # Activate.
  defined?(RSpec) and RSpec.configure do |config|
    config.extend IncludeDirContext::Exports
  end
end; end



# TODO: Fin.
# RSpec.configure do |config|
#   config.extend Module.new {
#     # Include hierarchical contexts from <tt>spec/</tt> up to spec root.
#     #
#     #   describe Something do
#     #     include_dir_context __dir__
#     #     ...
#     def include_dir_context(dir)
#       # Compute root based on this file location.
#       spec_root = File.expand_path("../..", __dir__)

#       d, steps = dir, []
#       while d.size >= spec_root.size
#         steps << d
#         d = File.split(d).first
#       end

#       steps.reverse.each do |d|
#         begin; include_context d; rescue ArgumentError; end
#       end

#       # A hack. We've got 2 sub-environments: plain and Rails, which share the same directory root.
#       # If we attempt to create 2 root contexts, RSpec will overwrite one with another.
#       # Hence we use distinct special names for root contexts and load them by hand.
#       begin; include_context "spec_top"; rescue ArgumentError; end
#       begin; include_context "rails_top"; rescue ArgumentError; end
#     end
#   } # config.extend
# end
