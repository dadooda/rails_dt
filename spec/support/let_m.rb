
extend_describe do
  # Add a variable, named <tt>m</tt> by default, containing the symbolized method name from the
  # description. Example:
  #
  #   describe "#some_method" do
  #     let_m
  #
  # , is identical to:
  #
  #   describe "#some_method" do
  #     let(:m) { :some_method }
  #     def self.m; :some_method; end
  #
  # @param let [Symbol] Name of the variable to create.
  # @return [void]
  def let_m(let = :m)
    if (mat = (description = self.description).match(/^(?:(?:#|\.|::)(\w+(?:\?|!|)|\[\])|(?:DELETE|GET|PUT|POST) (\w+))$/))
      s = mat[1] || mat[2]
      sym = s.to_sym
      let(let) { sym }
      define_singleton_method(let) { sym }
    else
      raise ArgumentError, "Unknown description format: #{description.inspect}"
    end
  end
end
