
require "pathname"

# Ruby/Rails debug toolkit.
#
# Features:
#
# * As simple as possible.
# * Suits Rails projects and stand-alone Ruby projects.
# * Has none or minimal dependencies.
# * Compatible with Ruby 1.9 and up.
#
# @see DT.p
module DT
  class Config
    attr_writer :root_path, :is_rails

    def initialize(attrs = {})
      attrs.each {|k, v| send("#{k}=", v)}
    end

    # @return [boolean]
    def is_rails
      if instance_variable_defined?(k = :@is_rails)
        instance_variable_get(k)
      else
        instance_variable_set(k, !!defined? Rails.logger)
      end
    end

    alias_method :rails?, :is_rails

    # @return [String]
    def root_path
      @root_path ||= if rails?
        # Rails project.
        Rails.root.to_s    # Already a `Pathname`.
      else
        # Non-Rails project, attempt to guess.
        if (fn = ENV["BUNDLE_GEMFILE"])
          # The project has a Gemfile, hook up to it.
          File.expand_path("..", __FILE__)
        else
          # Default to pwd otherwise.
          Dir.pwd
        end
      end
    end
  end # Config

  class Instance
    attr_writer :conf, :rails_logger, :stderr

    # The configuration object.
    #
    # @return [DT::Config]
    def conf
      @conf ||= Config.new
    end

    # Lower level implementation of <tt>p</tt>. <tt>caller</tt> is mandatory.
    # @return nil
    def _p(args, caller)
      file, line = caller[0].split(":")
      file_rel = begin
        Pathname(file).relative_path_from(Pathname(conf.root_path))
      rescue ArgumentError
        # If `file` is "" or other non-path, `relative_path_from` will raise an error.
        # Fall back to original value then.
        file
      end

      args.each do |arg|
        value = case arg
        when String
          arg
        else
          arg.inspect
        end

        msg = "[DT #{file_rel}:#{line}] #{value}"
        conf.rails?? rails_logger.debug(msg) : stderr.puts(msg)
      end

      # Be like `puts`.
      nil
    end

    # An object to use as log in Rails mode. Default is <tt>Rails.logger</tt>.
    #
    # @return [ActiveSupport::Logger]
    def rails_logger
      @rails_logger ||= Rails.logger
    end

    # A writable IO stream to print to in non-Rails mode. Default is <tt>STDERR</tt>.
    #
    # @return [IO]
    def stderr
      @stderr ||= STDERR
    end
  end # Instance

  class << self
    attr_writer :instance

    # @return [Config]
    def conf
      instance.conf
    end

    # @return [Instance]
    def instance
      @instance ||= Instance.new
    end

    # Print a debug message, dump values etc.
    #
    #   DT.p "checkpoint 1"
    #   DT.p "user", user
    def p(*args)
      instance._p(args, caller)
    end
  end # class << self
end

#
# Implementation notes:
#
# * `instance` is an OTF-computed value, thus there must be a writer.
#   Since there's a writer, it's public by definition.
