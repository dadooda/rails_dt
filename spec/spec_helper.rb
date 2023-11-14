
# Must go before all.
require_relative "support/simplecov"

# Self.
require "rails_dt"

# Load support files. Sorted alphabetically for greater control.
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |fn| require fn }

# Load directory-based contexts from across the tree.
# See `RSpecMagic::Stable::IncludeDirContext`.
Dir[File.expand_path("../**/_context.rb", __dir__)].each { |fn| require fn }
