# frozen_string_literal: true

require "attr_magic"
require "pathname"

require_relative "feature/initialize"

module DY
  # The environment we run in. Most features are auto-discovered.
  class Environment
    AttrMagic.load(self)
    DY::Feature::Initialize.load(self)

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
      igetset(__method__) { ENV.to_h }
    end

    # Path to current working directory as per +Dir.pwd+.
    # @return [String]
    def pwd
      igetset(__method__) { Dir.pwd }
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
          Pathname.new(s).realpath
        rescue Errno::ENOENT
          Pathname.new(s)
        end
      end
    end

    private

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
  end # Environment
end
