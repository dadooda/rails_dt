# frozen_string_literal: true

require "attr_magic"

require_relative "config"
require_relative "feature/initialize"
require_relative "instance/full_msg"
require_relative "instance/options/do_p"
require_relative "instance/options/fn"
require_relative "target/console"

module DY
  # Main class. Singleton module creates its instance under the hood and delegates
  # methods like {DY.p} and {DY.fn} to this instance.
  class Instance
    AttrMagic.load(self)
    DY::Feature::Initialize.load(self)

    # @return [Config]
    attr_accessor :conf

    # @return [Environment]
    def envi
      igetset(__method__) { Environment.new }
    end

    # OPTIMIZE: Document this, `Proc` specifically.
    # @param [Hash] options Attributes for an {Options::Fn}.
    # @return [Proc]
    def fn(options = {})
      o = Options::Fn.new(options)
      o.mute and return(-> (caller_line, args) {})

      vo = {}
      vo[:prefix] = o.prefix if o.prefix

      # Return this lambda.
      -> (caller_line, args) do
        do_p(caller_line, args, vo)
      end
    end

    # Actually print. Return the last argument.
    # @param [String] caller_line
    # @param [Array<mixed>] args Messages/values.
    # @param [Hash] options Attributes for an {Options::DoP}.
    # @return [mixed]
    def do_p(caller_line, args, options = {})
      # NOTE: We consider `#do_p1` a primitive, which thus takes a ready-made object.
      oo = Options::DoP.new(options)
      out = nil
      args.each { |arg| out = do_p1(caller_line, arg, oo) }
      out
    end

    # Return active targets.
    #
    #   targets   # => [:console, :log]
    #
    # @return [Array<Symbol>]
    def targets
      [
        (:console if conf.console.enabled),
      ].compact
    end

    private

    # A private attribute for well-balanced tests.
    attr_writer :envi, :t_console, :t_log, :t_rails

    # Print a single message/value. Return +arg+.
    # @param [String] caller_line
    # @param [mixed] arg
    # @param [Options::DoP] o
    # @return [mixed] arg
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

      arg
    end

    # Print to the named target if one is enabled.
    # @param [String] fullmsg
    def print_to_console(fullmsg)
      t_console.print(fullmsg) if conf.console.enabled
    end

    # Print to the named target if one is enabled.
    # @param [String] fullmsg
    def print_to_log(fullmsg)
      t_log.print(fullmsg) if conf.log.enabled
    end

    # Print to the named target if one is enabled.
    # @param [String] fullmsg
    def print_to_rails(fullmsg)
      t_rails.print(fullmsg) if conf.rails.enabled && t_rails
    end

    # The console target.
    # @return [Target::Console]
    def t_console
      igetset(__method__) { Target::Console.new }
    end

    # The log target.
    # @return [Target::Log]
    def t_log
      igetset(__method__) { Target::Log.new(root_path: envi.root_path) }
    end

    # The Rails target.
    # @return [Target::Rails]
    # @return [nil]
    def t_rails
      igetset(__method__) { Target::Rails.new(rails: envi.rails) if envi.rails }
    end
  end
end
