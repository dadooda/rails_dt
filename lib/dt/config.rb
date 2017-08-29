
require_relative "../dt"

module DT
  class Config
    attr_writer :env, :is_rails, :rails, :root_path

    def initialize(attrs = {})
      attrs.each {|k, v| send("#{k}=", v)}
    end

    # @return [mixed] Hash-like object. Default is <tt>ENV</tt>.
    def env
      @env ||= ENV
    end

    # @return [boolean]
    def is_rails
      if instance_variable_defined?(k = :@is_rails)
        instance_variable_get(k)
      else
        instance_variable_set(k, !!rails)
      end
    end

    alias_method :rails?, :is_rails

    # @return [Module] Top-level Rails module or substitute value. Default is <tt>Rails</tt> or <tt>nil</tt>.
    def rails
      if instance_variable_defined?(k = :@rails)
        instance_variable_get(k)
      else
        instance_variable_set(k, (Rails if defined? Rails))
      end
    end

    # @return [String]
    def root_path
      @root_path ||= if rails?
        # Rails project.
        rails.root.to_s    # Already a `Pathname`.
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
    end
  end
end
