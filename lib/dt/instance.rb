
require_relative "../dt"

module DT
  class Instance
    attr_writer \
      :conf,
      :dt_logger,
      :is_rails_console,
      :rails_logger,
      :stderr

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # The configuration object.
    # @return [Config] <tt>DT.conf</tt>.
    def conf
      # NOTE: See "Implementation notes".
      @conf ||= DT.conf
    end

    # File logger, an instance of Ruby's <tt>Logger</tt>.
    # @return [Logger] Default is a <tt>Logger</tt> writing to <tt>log/dt.log</tt>.
    def dt_logger
      if instance_variable_defined?(k = :@dt_logger)
        instance_variable_get(k)
      else
        instance_variable_set(k, begin
          Logger.new(conf.root_path + "log/dt.log")
        rescue Errno::ENOENT
          nil
        end)
      end
    end

    # <tt>true</tt> if running in Rails console.
    # @return [Boolean]
    def is_rails_console
      if instance_variable_defined?(k = :@is_rails_console)
        instance_variable_get(k)
      else
        instance_variable_set(k, conf.rails && conf.rails.const_defined?(:Console))
      end
    end
    alias_method :rails_console?, :is_rails_console

    # An object to use as log in Rails mode.
    # @return [ActiveSupport::Logger] Default is <tt>conf.rails.logger</tt>.
    def rails_logger
      if instance_variable_defined?(k = :@rails_logger)
        instance_variable_get(k)
      else
        instance_variable_set(k, conf.rails && conf.rails.logger)
      end
    end

    # A writable IO stream to print to. Default is <tt>STDERR</tt>.
    # @return [IO]
    def stderr
      @stderr ||= STDERR
    end

    #--------------------------------------- Actions

    # Lower level implementation of <tt>p</tt>.
    #
    # * Print to {#dt_logger} if one is available.
    # * Print to {#rails_logger} if one is available.
    # * Print to {#stderr} if not running in {#rails_console?}.
    #
    # @param caller [Array<Array<file, line>>]
    # @return nil
    # @see DT.p
    def _p(caller, *args)
      file, line = caller[0].split(":")
      file_rel = begin
        Pathname(file).relative_path_from(conf.root_path)
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

        # Fire!
        dt_logger.debug(msg) if dt_logger
        if rails_logger
          rails_logger.debug(msg)
          stderr.puts(msg) if stderr && !rails_console?
        else
          stderr.puts(msg) if stderr
        end
      end

      # Be like `puts`.
      nil
    end
  end
end

#
# Implementation notes:
#
# * `DT.conf` acts as a subsystem-wide global, all instance copies point to the same object. The
#   reason for that is that it's possible that certain configuration options will be added in the
#   future.
