# frozen_string_literal: true

require "pathname"

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"

"LODoc"

module DY
  # The environment we run in. Most features are auto-discovered.
  class Environment
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    # TODO: Fin.
    # attr_writer :env

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

    # Path to current working directory as per +Dir.pwd+.
    # @return [String]
    def pwd
      igetset(__method__) do
        Dir.pwd
      end
    end

    # Top-level Rails module, if one is available.
    # @return [Module] +Rails+.
    # @return [nil]
    def rails
      # Two ways to use this method:
      #
      # 1. As an optional external dependency.
      # 2. As an environment indicator.
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
        s = root_path_of_rails || root_path_of_bundler || pwd
        begin
          # TODO: Get rid of `xd_*`.
          xd_pathname.new(s).realpath
        rescue Errno::ENOENT
          xd_pathname.new(s)
        end
      end
    end

    private

    # TODO: Retro-fix siblings. Consistent doc comment below.

    # A private attribute for well-balanced tests.
    attr_writer :env, :gemfile, :pwd, :rails, :root_path, :root_path_of_bundler, :root_path_of_rails

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

    # TODO: CUP.
    # External dependency.
    # @return [Pathname]
    def xd_pathname
      @xd_pathname ||= Pathname
    end
  end # Environment
end
