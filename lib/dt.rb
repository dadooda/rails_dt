
require "logger"
require "pathname"

# Ruby/Rails debug toolkit.
#
# Features:
#
# * As simple as possible.
# * Suits Rails projects and stand-alone Ruby projects.
# * Has none or minimal dependencies.
# * Compatible with Ruby 1.9 and up.
#
# @see DT.p
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

    # Print a debug message, dump values etc.
    #
    #   DT.p "checkpoint 1"
    #   DT.p "user", user
    #
    # @return [nil]
    # @see Instance#_p
    def p(*args)
      instance._p(caller, *args)
    end
  end # class << self
end
