
extend_describe do
  # Create a `context "when ..."`, with a set of let variables defined.
  #
  #   context_when a: 1, x: "y" do
  #     it { expect(a).to eq 1 }      # Success.
  #     it { expect(x).to eq "y" }    # Success.
  #   end
  #
  # , is identical to:
  #
  #   context "when {a: 1, x: \"y\"}" do
  #     let(:a) { 1 }
  #     let(:x) { "y" }
  #     ...
  #
  # @param h [Hash]
  # @param format_proc [Proc]
  # @return [void]
  def context_when(h, format_proc: context_when_default_format_proc, &block)
    context format_proc[h] do
      h.each do |k, v|
        let(k) { v }
      end
      class_eval(&block)
    end
  end

  # Default <tt>format_proc</tt> for {.context_when}.
  # @return [Proc]
  # @see .context_when
  def context_when_default_format_proc
    ->(h) do
      # Primitive readability hack. Might screw string values, too.
      inspected = h.inspect.gsub(/:(\w+)=>/, "\\1: ")
      "when #{inspected}"
    end
  end
end
