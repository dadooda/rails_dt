
require "json"

RSpec.describe ".context_when" do
  context "when default" do
    context_when a: 1, "b" => 2, x: "y" do
      description = self.description
      it { expect(description).to eq 'when {a: 1, "b"=>2, x: "y"}' }
      it { expect { c }.to raise_error(NameError, /^undefined local variable or method `c'/) }
      it { expect([a, b, x]).to eq [1, 2, "y"] }
    end
  end

  context "when customized" do
    context_when({a: 1, x: "y"}, format_proc: ->(h) { "when #{h.to_json}" }) do
      description = self.description
      it { expect(description).to eq 'when {"a":1,"x":"y"}' }
      it { expect([a, x]).to eq [1, "y"] }
    end
  end

  context "with `def` in the block" do
    context_when a: 1 do
      def ar
        [a, 2]
      end

      it { expect(a).to eq 1 }
      it { expect(ar).to eq [1, 2] }
    end
  end
end
