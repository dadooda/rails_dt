# frozen_string_literal: true

module DT
  describe Eenst do
    use_letset(:let_a, :attrs)
    use_method_discovery :m

    let(:obj) { described_class.new(attrs) }

    describe "function methods" do
      # TODO: Fin.
      # # Generic caller info.
      # CALLER1 = [
      #   "/path/to/project/file1.rb:201:in `meth'",
      #   "/path/to/project/file2.rb:403:in `handle_line'",
      #   "/path/to/project/file3.rb:504:in `block (2 levels) in eval'",
      # ]

      # NOTE: At least some of the function methods are usually private.
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "#extract_file_line" do
        context_when args: ["/path/to/project/file1.rb:201:in `meth'"] do
          it { is_expected.to eq ["/path/to/project/file1.rb", "201"] }
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

      describe "#format_full_loc and #format_loc" do
        let_a(:konf) { double("konf") }

        # NOTE: `full_loc` is actually a shorter variant of `format_full_loc_result`.
        let(:full_loc) { obj.send(:format_full_loc, *args) }
        let(:loc) { obj.send(:format_loc, *args) }

        before :each do
          defined?(efl_result) and allow(obj).to receive(:extract_file_line).and_return(efl_result)
          defined?(ffr_result) and allow(obj).to receive(:format_file_rel).and_return(ffr_result)

          defined?(loc_length) and allow(konf).to receive(:loc_length).and_return(loc_length)
        end

        context_when args:[["*"]], efl_result: ["**", "201"], loc_length: 20 do
          context_when ffr_result: "../to/file.rb" do
            it "generally works" do
              expect(full_loc).to eq "../to/file.rb:201"
              expect(loc).to eq "   ../to/file.rb:201"
              expect(loc.length).to eq loc_length
            end

          end

          context_when ffr_result: "../to/very_long_path/extremely_long_file..rb" do
            it "generally works" do
              expect(full_loc).to eq "../to/very_long_path/extremely_long_file..rb:201"
              expect(loc).to eq "…y_long_file..rb:201"
              expect(loc.length).to eq loc_length
            end
          end
        end
      end # describe "location functions"
    end # describe "function methods"

    # OPTIMIZE: A few sporadic end-to-end tests.
  end # describe
end
