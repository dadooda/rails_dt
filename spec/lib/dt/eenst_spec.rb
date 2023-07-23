# frozen_string_literal: true

module DT
  describe Eenst do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    describe "function methods" do
      # NOTE: Some, if not all of the function methods are private.
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "#extract_file_line" do
        context_when args: ["/path/to/file.rb:123:in `some_meth'"] do
          it { is_expected.to eq ["/path/to/file.rb", "123"] }
        end
      end

      describe "#format_file_rel" do
        let_a(:envi) { double("envi") }

        before :each do
          defined?(root_path) and allow(envi).to receive(:root_path).and_return(Pathname(root_path))
        end

        context_when root_path: "/some/path" do
          context_when args: ["just_a_file.rb"] do
            it { is_expected.to eq "just_a_file.rb" }
          end

          context_when args: ["/some/path/to/file.rb"] do
            it { is_expected.to eq "to/file.rb" }
          end

          context_when args: ["/some/other/file.rb"] do
            it { is_expected.to eq "../other/file.rb" }
          end
        end
      end # describe "#format_file_rel"

      describe "#format_location" do
        before :each do
          defined?(ffr_result) and allow(obj).to receive(:format_file_rel).and_return(ffr_result)
        end

        context_when args:["yoo moo"] do
          context_when xxxffr_result: "keke" do
            it do
              subject
            end
          end
        end

        # it do
        #   p "subject", eval("[subject]")
        #   # p "subject", subject
        # end
      end
    end # describe "function methods"
  end # describe
end
