# frozen_string_literal: true

module DT
  describe Eenst do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    describe "function methods" do
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "#extract_file_line" do
        context_when args: ["/path/to/file.rb:123:in `some_meth'"] do
          it { is_expected.to eq ["/path/to/file.rb", "123"] }
        end
      end

      describe "#format_file_rel" do
        context "when eval" do
          pending("find live examples")
        end

        context_when args: ["/some/path/to/file.rb"] do
          let_a(:envi) { double("envi") }

          it do
            allow(envi).to receive(:root_path).and_return(Pathname("/some/path"))
            is_expected.to eq "to/file.rb"
          end
        end
      end

      xdescribe "#format_location" do
        it do
          p "subject", eval("[subject]")
          # p "subject", subject
        end
      end
    end # function methods
  end # describe
end
