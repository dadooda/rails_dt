
RSpec.describe DT do
  subject { described_class.public_send(m) }

  describe ".conf" do
    let_m
    it { is_expected.to be_a described_class::Config }
  end

  describe ".instance" do
    let_m
    it { is_expected.to be_a described_class::Instance }
  end
end
