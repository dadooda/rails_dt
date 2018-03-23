
require "pathname"

require_relative "../dt"

module DT
  class Config
    attr_writer :env, :rails

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # A copy of <tt>ENV</tt> for value-reading purposes.
    # @return [Hash] Default is <tt>ENV.to_h</tt>.
    def env
      @env ||= ENV.to_h
    end

    # Top-level Rails module or substitute value.
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
    # @return [Pathname]
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

        # 2. Attempt to absolutize raw path, but in a non-fatal way.
        begin
          # See "Implementation notes".
          Pathname(s).realpath
        rescue Errno::ENOENT
          Pathname(s)
        end
      end
    end

    def root_path=(s)
      @root_path = if s.is_a? Pathname
        s
      else
        Pathname(s)
      end
    end
  end
end

#
# Implementation notes:
#
# * We call `Pathname` as `Pathname` to be able to stub them as own methods during testing. Other
#   than that we should be using `Kernel.Pathname` which is also usable, but is more ugly.
