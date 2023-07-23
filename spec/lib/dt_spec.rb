
describe DT do
  use_method_discovery :m

  subject { described_class.public_send(m) }

  describe ".conf" do
    it { is_expected.to be_a described_class::Config }
  end

  describe ".instance" do
    it { is_expected.to be_a described_class::Instance }
  end
end
