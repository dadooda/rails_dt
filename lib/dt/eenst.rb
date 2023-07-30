
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

    # TODO: Fin.
    # # Extract file and line information.
    # # @param [String] caller_line E.g. <tt>"/path/to/project/file1.rb:201:in `meth'"</tt>.
    # # @return [[String, String]] File and line number.
    # def extract_file_line(caller_line)
    #   ar = caller_line.split(":")[0..1]
    #   if ar.size == 2 && ar[1].length > 0
    #     ar
    #   else
    #     # Misformatted input. Keep the full original, stuff "?" as line number.
    #     [caller_line, "?"]
    #   end
    # end

    # # Format a relative file path.
    # # @param [String] file
    # # @return [String]
    # def format_file_rel(file)
    #   begin
    #     xd_pathname.new(file).relative_path_from(envi.root_path).to_s
    #   rescue ArgumentError => e
    #     # Handle known errors only:
    #     #
    #     #   different prefix: "" and "/some/path"'
    #     #
    #     # Default to `file` as is.
    #     if e.message.start_with? "different prefix:"
    #       file
    #     else
    #       raise e
    #     end
    #   end
    # end

    # # Format a +%{full_loc}+ message token.
    # # @param [String] caller_line
    # # @return [String]
    # def format_full_loc(caller_line)
    #   file, line = extract_file_line(caller_line)
    #   [format_file_rel(file), line].join(":")
    # end

    # # Format a +%{loc}+ message token.
    # # @param [String] caller_line
    # # @return [String]
    # def format_loc(caller_line)
    #   limit = konf.loc_length
    #   full = format_full_loc(caller_line)
    #   truncated = full[-(limit - 1)..-1]

    #   if truncated
    #     "…" + truncated
    #   else
    #     # Right-align.
    #     sprintf "%*s", limit, full
    #   end
    # end

    # # Format a mixed value into an +%{msg}+ message token.
    # #
    # #   format_msg("hey")   # => "hey"
    # #   format_msg(1.5)     # => "5.5"
    # #
    # # @param [mixed] arg
    # # @return [String]
    # def format_msg(arg)
    #   # NOTE: This thing doesn't know anything about `DT::Option`.
    #   arg.is_a?(String) ? arg : arg.inspect
    # end

    # # Create the message tokens hash.
    # # @param [String] caller_line
    # # @param [String] msg
    # # @return [Hash]
    # def make_tokens(caller_line, msg)
    #   {
    #     full_loc: format_full_loc(caller_line),
    #     loc: format_loc(caller_line),
    #     msg: msg,
    #   }
    # end

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
