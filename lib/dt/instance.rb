
require_relative "../dt"

module DT
  class Instance
    attr_writer :conf, :dt_logger, :stderr

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }
    end

    # The configuration object.
    # @!attribute conf
    # @return [Config]
    def conf
      @conf ||= Config.new
    end

    # File logger, an instance of Ruby's <tt>Logger</tt>. Writes to <tt>log/dt.log</tt> if sufficient permissions.
    # @!attribute dt_logger
    # @return [Logger]
    def dt_logger
      if instance_variable_defined?(k = :@dt_logger)
        instance_variable_get(k)
      else
        instance_variable_set(k, begin
          Logger.new(File.join(conf.root_path, "log/dt.log"))
        rescue Errno::ENOENT
          nil
        end)
      end
    end

    # Lower level implementation of <tt>p</tt>.
    # @param caller [Array<Array<file, line>>]
    # @return nil
    # @see DT.p
    def _p(caller, *args)
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
        stderr.puts(msg)
        dt_logger.debug(msg) if dt_logger
      end

      # Be like `puts`.
      nil
    end

    # A writable IO stream to print to. Default is <tt>STDERR</tt>.
    # @return [IO]
    def stderr
      @stderr ||= STDERR
    end
  end
end
