
require "logger"
require "pathname"

"LODoc"

# Ruby/Rails debug toolkit.
#
# = Usage
#
#   DT.p "checkpoint 1"
#   DT.p "user", user
#
# = Features
#
# * As simple as possible.
# * Suits Rails projects and stand-alone Ruby projects.
# * Has none or minimal dependencies.
# * Compatible with Ruby 1.9 and up.
#
# Print a debug messages, dump values etc:
module DT
  require_relative "dt/config"
  require_relative "dt/instance"

  class << self
    attr_writer :conf, :instance

    # @return [Config]
    def conf
      @conf ||= Config.new
    end

    # @return [Instance]
    def instance
      @instance ||= Instance.new
    end

    #
    # @return [nil]
    # @see Instance#_p
    def p(*args)
      instance._p(caller, *args)
    end
  end # class << self
end
