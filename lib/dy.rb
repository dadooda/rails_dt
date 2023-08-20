
require_relative "dy/config"
require_relative "dy/instance"

# Alternative drop-in module with new functionality.
#
# «Y» is on the right of «T» on the keyboard. 😊
module DY
  class << self
    # @return [Config]
    def conf
      @conf ||= Config.new
    end

    # OPTIMIZE: Make a synthetic object clearly listing enabled targets.
    #   `def targets` or something.
    #   `def target_info` or something. With paths.
    #   The user might be interested in why aren't we logging.

    # TODO: Based on LODoc we must give concrete real-life examples.
    # @param [Hash] options Attributes for an {DY::Instance::Options::Fn}.
    # @return [Proc]
    # @note OPTIMIZE: Document `Proc` and everything.
    def fn(options = {})
      ifn = instance.fn(options)

      ->(*args) do
        ifn.(caller[0], args)
      end
    end

    # Print messages/values to all enabled targets.
    # @param [Array<mixed>] args Messages/values.
    # @return [nil]
    def p(*args)
      send(:instance).do_p(caller[0], args)
    end

    private

    # TODO: I doubt if we really need writable attrs in a singleton.
    #       That would indeed screw the tests up.
    #       Try to go without them for now.
    #       TODO: Fin.

    # @note These are for well-balanced and consistent tests.
    #attr_writer :conf, :envi, :instance

    # @return [Instance]
    def instance
      @instance ||= Instance.new(conf: conf)
    end
  end # class << self
end
