
# Load directory-based contexts from across the tree.
# See `RSpecMagic::Stable::IncludeDirContext`.
Dir[File.expand_path("../**/_context.rb", __dir__)].each { |fn| require fn }
