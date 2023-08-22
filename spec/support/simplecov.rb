
#
# See https://github.com/simplecov-ruby/simplecov#getting-started.
#

require "simplecov"

SimpleCov.start do
  add_filter "spec/"
  # TODO: Fin.
  add_filter "lib/dt.rb"
  add_filter "lib/dt/"
end
