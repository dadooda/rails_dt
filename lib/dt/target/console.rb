
require_relative "base"

module DT; module Target
  class Console < Base
    # Print a full message.
    # @param [String] fullmsg
    def print(fullmsg)
      xd_stderr.puts(fullmsg)
    end

    private

    # External dependency.
    # @return [IO] +STDERR+.
    def xd_stderr
      @xd_stderr ||= STDERR
    end
  end
end; end
