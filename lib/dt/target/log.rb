
require_relative "base"

module DT; module Target
  class Log < Base
    # TODO: `root_path` here

    # @param [String] fullmsg
    # @return [nil]
    def print(fullmsg)
      p "#{self.class}#{__method__} #{fullmsg}"
      #xd_stderr.puts(fullmsg)
    end

    private

    # @return [Logger]
    def logger
      igetset(:dt_logger) do
        "prrr!"
        # begin
        #   # OPTIMIZE: Make configurable.
        #   Logger.new(conf.root_path + "log/dt.log").tap do |_|
        #     # TODO: Fin. Make configurable. See dlogger for tokenized format.
        #     _.formatter = proc do |severity, time, progname, msg|
        #       "#{time.strftime('%Y-%m-%d %H:%M:%S')} #{msg}\n"
        #     end
        #   end
        # rescue Errno::ENOENT
        #   nil
        # end
      end
    end


  end
end; end
