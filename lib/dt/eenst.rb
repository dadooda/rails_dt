# frozen_string_literal: true

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"
require_relative "eenst/full_msg"
require_relative "eenst/options/fn"
require_relative "eenst/options/p"
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

    # TODO: Fin.
    #
    # @param [Hash] options Trr-ta, trr-ta.
    #   Hop hop hop!
    #     kode kode
    #
    # @return [Proc]
    def fn(options = {})
      o = Options::Fn.new(options)
      o.mute and return(->(caller_line, args) {})

      vo = {}
      vo[:prefix] = o.prefix if o.prefix

      ->(caller_line, args) do
        do_p(caller_line, args, vo)
      end
    end

    # @return [Konf]
    def konf
      @konf ||= Konf.new
    end

    # Actually print.
    # @param [String] caller_line
    # @param [Array<mixed>] args Messages/values.
    # @param [Hash] options Attributes for an {Options::P}.
    # @return [nil]
    def do_p(caller_line, args, options = {})
      o = Options::P.new(options)
      args.each { |arg| do_p1(caller_line, arg, o) }
      nil
    end

    private

    # Print a single message/value to all enabled targets.
    # @param [String] caller_line
    # @param [mixed] arg
    # @param [o] Options::P
    def do_p1(caller_line, arg, o)
      fullmsg = FullMsg.new({
        arg: arg,
        caller_line: caller_line,
        format: konf.format,
        loc_length: konf.loc_length,
        prefix: o.prefix,
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
      @t_log ||= Target::Log.new(root_path: envi.root_path)
    end
  end
end
