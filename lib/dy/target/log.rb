
require_relative "base"

module DY; module Target
  class Log < Base
    # @return [Pathname]
    attr_accessor :root_path

    # Print a full message.
    # @param [String] fullmsg
    # @note The message is output only if the logger was able to open itself successfully.
    def print(fullmsg)
      logger.debug(fullmsg) if logger
    end

    private

    # A private attribute for well-balanced tests.
    attr_writer :formatter, :logger, :relative_filename

    # OPTIMIZE: Document this consistently.
    # @return [Proc]
    def formatter
      igetset(__method__) do
        ->(severity, time, progname, msg) do
          "#{time.strftime('%Y-%m-%d %H:%M:%S')} #{msg}\n"
        end
      end
    end

    # @return [Logger]
    def logger
      igetset(__method__) do
        require_attr :relative_filename
        require_attr :root_path

        begin
          Logger.new(root_path + relative_filename).tap do |_|
            _.formatter = formatter
          end
        rescue Errno::ENOENT
          nil
        end
      end
    end

    # @return [String]
    def relative_filename
      igetset(__method__) { "log/dt.log" }
    end
  end
end; end
