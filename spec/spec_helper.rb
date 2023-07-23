
# Must go before all. See https://github.com/simplecov-ruby/simplecov#getting-started.
require "simplecov"; SimpleCov.start

# Self.
require "rails_dt"

# Load support files. Sorted alphabetically for greater control.
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |fn| require fn }
