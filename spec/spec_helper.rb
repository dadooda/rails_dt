
# Must go before all.
require_relative "support/simplecov"

# Self.
require "rails_dt"

# Load support files. Sorted alphabetically for greater control.
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |fn| require fn }
