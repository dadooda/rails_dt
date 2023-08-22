
module DY; module Target
  describe Base do
    use_method_discovery :m

    describe "abstract methods" do
      let(:klass) { Class.new(described_class) }
      let(:obj) { klass.new }
      subject { obj.public_send(m, *(defined?(args) ? args : [])) }

      def self.it_is_abstract
        it "is abstract" do
          expect { subject }.to raise_error(NotImplementedError, /Redefine.+your class/)
        end
      end

      describe "#print" do
        let(:args) { ["full message"] }
        it_is_abstract
      end
    end
  end
end; end
