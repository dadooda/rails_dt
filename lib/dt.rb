
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
    attr_writer :instance

    # @return [Config]
    def conf
      instance.conf
    end

    # @return [Instance]
    def instance
      @instance ||= Instance.new
    end

    # Print a debug message, dump values etc.
    #
    #   DT.p "checkpoint 1"
    #   DT.p "user", user
    def p(*args)
      instance._p(caller, *args)
    end
  end # class << self
end

#
# Implementation notes:
#
# * `instance` is an OTF-computed value, thus there must be a writer.
#   Since there's a writer, it's public by definition.
