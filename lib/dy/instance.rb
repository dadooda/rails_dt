# frozen_string_literal: true

require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"
require_relative "config"
require_relative "instance/full_msg"
require_relative "instance/options/do_p"
require_relative "instance/options/fn"
require_relative "target/console"

module DY
  # Main class. Singleton module creates its instance under the hood and delegates
  # methods like {DY.p} and {DY.fn} to this instance.
  class Instance
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :envi

    # @return [Config]
    attr_accessor :conf

    # @return [Environment]
    def envi
      @envi ||= Environment.new
    end

    # @param [Hash] options Attributes for an {Options::Fn}.
    # @return [Proc]
    # @note OPTIMIZE: Document this, `Proc` specifically.
    def fn(options = {})
      o = Options::Fn.new(options)
      o.mute and return(->(caller_line, args) {})

      vo = {}
      vo[:prefix] = o.prefix if o.prefix

      ->(caller_line, args) do
        do_p(caller_line, args, vo)
      end
    end

    # Actually print.
    # @param [String] caller_line
    # @param [Array<mixed>] args Messages/values.
    # @param [Hash] options Attributes for an {Options::DoP}.
    # @return [nil]
    def do_p(caller_line, args, options = {})
      o = Options::DoP.new(options)
      args.each { |arg| do_p1(caller_line, arg, o) }
      nil
    end

    private

    # Print a single message/value.
    # @param [String] caller_line
    # @param [mixed] arg
    # @param [Options::DoP] o
    def do_p1(caller_line, arg, o)
      require_attr :conf

      fullmsg = FullMsg.new({
        arg: arg,
        caller_line: caller_line,
        format: conf.format,
        loc_length: conf.loc_length,
        prefix: o.prefix,
        root_path: envi.root_path,
      }).formatted

      print_to_console(fullmsg)
      print_to_log(fullmsg)
      print_to_rails(fullmsg)
    end

    # Print to the console target if one is enabled.
    # @param [String] fullmsg
    def print_to_console(fullmsg)
      t_console.print(fullmsg) if conf.console.enabled
    end

    def print_to_log(fullmsg)
      t_log.print(fullmsg) if conf.log.enabled
    end

    def print_to_rails(fullmsg)
      t_rails.print(fullmsg) if conf.rails.enabled
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

    # The Rails target.
    # @return [Target::Rails]
    def t_rails
      @t_rails ||= Target::Rails.new
    end
  end
end