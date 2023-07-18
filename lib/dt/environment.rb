
require "pathname"

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"

"LODoc"

module DT
  # The environment we run in. Most features are auto-discovered.
  class Environment
    ::Feature::AttrMagic.load(self)
    ::Feature::Initialize.load(self)

    # TODO: Fin.
    attr_writer :env
    # attr_writer :bundle_gemfile, :rails, :root_path

    # A path to +Gemfile+, if any. Retrieved from <tt>env["BUNDLE_GEMFILE"]</tt>.
    # @return [String]
    # @return [nil]
    def gemfile
      igetset(:gemfile) do
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
      igetset(:rails) do
        # NOTE: We look up relative name to allow for smart testing.
        Rails if defined? Rails
      end
    end

    # # Root path of the project we run in.
    # # @return [Pathname]
    # def root_path

    # end

    # private

    # def root_path_of_bundler
    # end

    # def root_path_of_rails
    #   igetset(:root_path_rails) do
    #     rails.root
    #   end
    # end
  end # Environment
end
