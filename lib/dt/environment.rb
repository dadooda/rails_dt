# frozen_string_literal: true

require "pathname"

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"

"LODoc"

module DT
  # The environment we run in. Most features are auto-discovered.
  class Environment
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :env

    # A path to +Gemfile+, if present in <tt>env["BUNDLE_GEMFILE"]</tt>.
    # @return [String]
    # @return [nil]
    def gemfile
      # OPTIMIZE: Document this case in `AttrMagic`.
      igetset(__method__) do
        env["BUNDLE_GEMFILE"]
      end
    end

    # A copy of +ENV+ for value-reading purposes.
    # @return [Hash] <i>(defaults to: +ENV.to_h+)</i>
    def env
      @env ||= ENV.to_h
    end

    # Top-level Rails module, if any.
    # @return [Module] +Rails+.
    # @return [nil]
    def rails
      # NOTE: In our case `Rails` isn't just an external dependency, but a part of the public interface.
      igetset(__method__) do
        # NOTE: We look up relative name to allow for smart testing.
        Rails if defined? Rails
      end
    end

    # Root path of the project we run in. Computed as:
    #
    # 1. Rails root if running under Rails.
    # 2. Path to +Gemfile+ if running under Bundler.
    # 3. +Dir.pwd+ otherwise.
    #
    # @return [Pathname]
    def root_path
      igetset(__method__) do
        s = root_path_of_rails || root_path_of_bundler || Dir.pwd
        begin
          xd_pathname(s).realpath
        rescue Errno::ENOENT
          xd_pathname(s)
        end
      end
    end

    private

    def xd_pathname
      @xd_pathname ||= Pathname
    end

    # @return [String]
    # @return [nil]
    def root_path_of_bundler
      igetset(__method__) do
        File.expand_path("..", gemfile) if gemfile
      end
    end

    # @return [String]
    # @return [nil]
    def root_path_of_rails
      igetset(__method__) do
        rails.root.to_s if rails
      end
    end
  end # Environment
end
