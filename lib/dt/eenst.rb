
require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"
require_relative "eenst/full_msg"
require_relative "konf"
require_relative "target/console"

module DT
  # Main class.
  class Eenst
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :envi, :konf

    # @return [Environment]
    def envi
      @envi ||= Environment.new
    end

    # @return [Konf]
    def konf
      @konf ||= Konf.new
    end

    # Actually print.
    # @param [String] caller_line
    # @param [Array<mixed>] args Messages/values.
    # @return [nil]
    def _p(caller_line, *args)
      raise "iniy"

      nil
    end

    private

    # Print a single message/value to all enabled targets.
    # @param [String] caller_line
    # @param [mixed] arg
    def _p1(caller_line, arg)
      fullmsg = FullMsg.new({
        arg: arg,
        caller_line: caller_line,
        format: konf.format,
        loc_length: konf.loc_length,
        root_path: envi.root_path,
      }).formatted

      print_to_console(fullmsg)
      print_to_log(fullmsg)
    end

    # Print to the console target if one is enabled.
    # @param [String] fullmsg
    def print_to_console(fullmsg)
      t_console.print(fullmsg) if konf.console.enabled
    end

    def print_to_log(fullmsg)
      t_log.print(fullmsg) if konf.log.enabled
    end

    # The console target.
    # @return [Target::Console]
    def t_console
      @t_console ||= Target::Console.new
    end

    # The log target.
    # @return [Target::Log]
    def t_log
      @t_log ||= Target::Log.new
    end

    # External dependency.
    # @return [Kernel]
    def xd_kernel
      @xd_kernel ||= Kernel
    end

    # External dependency.
    # @return [Pathname]
    def xd_pathname
      @xd_pathname ||= Pathname
    end
  end
end
