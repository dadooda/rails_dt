
RSpec.describe ".let_m" do
  describe "describe/it scope" do
    describe "#some_method" do
      let_m
      self_m = m
      it { expect(self_m).to eq :some_method }
      it { expect(m).to eq :some_method }
    end
  end

  describe "`let` argument handling" do
    describe "#some_method" do
      let_m(:x)
      self_x = x
      it { expect(self_x).to eq :some_method }
      it { expect(x).to eq :some_method }
    end
  end

  context "when invalid argument like ..." do
    def self.doit
      # OPTIMIZE: There's a more optimal implementation of this in `extract_to_spec.rb`.
      begin; let_m; rescue ArgumentError => e; let(:message) { e.message }; end
    end

    describe "#some_method!!" do
      doit
      it { expect(message).to eq "Unknown description format: \"#some_method!!\"" }
    end

    describe "#some method" do
      doit
      it { expect(message).to eq "Unknown description format: \"#some method\"" }
    end

    describe "method" do
      doit
      it { expect(message).to eq "Unknown description format: \"method\"" }
    end
  end

  context "when valid argument like ..." do
    describe "#some_method" do
      let_m
      it { expect(m).to eq :some_method }
    end

    describe "#some_method?" do
      let_m
      it { expect(m).to eq :some_method? }
    end

    describe "#some_method!" do
      let_m
      it { expect(m).to eq :some_method! }
    end

    describe ".some_method" do
      let_m
      it { expect(m).to eq :some_method }
    end

    describe "::some_method" do
      let_m
      it { expect(m).to eq :some_method }
    end

    describe "#[]" do
      let_m
      it { expect(m).to eq :[] }
    end

    describe ".[]" do
      let_m
      it { expect(m).to eq :[] }
    end

    describe "::[]" do
      let_m
      it { expect(m).to eq :[] }
    end

    describe "GET some_action" do
      let_m
      it { expect(m).to eq :some_action }
    end

    describe "POST some_action" do
      let_m
      it { expect(m).to eq :some_action }
    end

    describe "PUT some_action" do
      let_m
      it { expect(m).to eq :some_action }
    end

    describe "DELETE some_action" do
      let_m
      it { expect(m).to eq :some_action }
    end
  end
end
