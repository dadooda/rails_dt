
RSpec.describe ".use_custom_let" do
  use_custom_let(:let_a, :attrs)

  describe "straight usage" do
    describe "attrs" do
      let_a(:name) { "Joe" }
      let_a(:age) { 25 }
      let(:gender) { :male }
      it do
        expect(name).to eq "Joe"
        expect(age).to eq 25
        expect(attrs).to eq(name: "Joe", age: 25)
        expect(attrs(include: [:gender])).to eq(name: "Joe", age: 25, gender: :male)
      end
    end
  end

  describe "declarative (no block) usage" do
    let_a(:name)

    subject { attrs }

    context "when no other `let` value" do
      it { is_expected.to eq({}) }
    end

    context "when `let`" do
      let(:name) { "Joe" }
      it { is_expected.to eq(name: "Joe") }
    end

    context "when `let_a`" do
      let_a(:name) { "Joe" }
      it { is_expected.to eq(name: "Joe") }
    end

    context_when name: "Joe" do
      context_when name: "Moe" do
        it { is_expected.to eq(name: "Moe") }
      end

      it { is_expected.to eq(name: "Joe") }
    end
  end
end
