
require "pathname"

require_relative "../dt"

module DT
  class Config
    attr_writer :env, :rails, :root_path

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # A copy of <tt>ENV</tt> for value-reading purposes. Default is <tt>ENV.to_hash</tt>.
    # @!attribute env
    # @return [Hash]
    def env
      @env ||= ENV.to_hash
    end

    # Top-level Rails module or substitute value.
    # @!attribute Rails
    # @return [Module] <tt>Rails</tt>.
    # @return [nil]
    def rails
      if instance_variable_defined?(k = :@rails)
        instance_variable_get(k)
      else
        instance_variable_set(k, (Rails if defined? Rails))
      end
    end

    # @!attribute root_path
    # @return [String]
    def root_path
      @root_path ||= begin
        # 1. Fetch "raw" value, suitable as `Pathname` argument.
        s = if rails
          # Rails project.
          rails.root
        else
          # Non-Rails project, attempt to guess.
          if (fn = env["BUNDLE_GEMFILE"])
            # The project has a Gemfile, hook it up.
            File.expand_path("..", fn)
          else
            # Default to pwd otherwise.
            Dir.pwd
          end
        end

        # 2. Absolutize raw path. If failure, fall back to original value. This is for the tests.
        begin
          Pathname(s).realpath
        rescue Errno::ENOENT
          s
        end.to_s
      end
    end
  end
end
