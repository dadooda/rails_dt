
#
# Convenience methods to extend RSpec metalanguage.
# This file must be loaded before other support files.
#

module Kernel
  def extend_describe(&block)
    raise ArgumentError, "Code block must be given" unless block

    ::RSpec.configure do |config|
      config.extend Module.new(&block)
    end
  end

  def extend_it(&block)
    raise ArgumentError, "Code block must be given" unless block

    ::RSpec.configure do |config|
      config.include Module.new(&block)
    end
  end
end
