
module DY
  describe Instance do
    use_letset(:let_a, :attrs)
    use_letset(:let_p, :pattrs)
    use_method_discovery :m

    let_a(:conf)

    let_p(:envi)
    let_p(:t_console)
    let_p(:t_log)
    let_p(:t_rails)

    let(:obj) do
      described_class.new(attrs).tap do |_|
        pattrs.each { |k, v| _.send("#{k}=", v) }
      end
    end

    describe "public methods" do
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "#envi" do
        pending("TODO")
      end
    end

    describe "private methods" do
      # NOTE: At least some of the function methods are usually private.
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "`t_*`" do
        let(:conf) { double "conf" }
        let(:conf_console) { double "conf.console" }
        let(:conf_log) { double "conf.log" }
        let(:conf_rails) { double "conf.rails" }
        let(:envi) { double "envi" }

        before :each do
          allow(conf).to receive(:console).and_return(conf_console)
          allow(conf).to receive(:log).and_return(conf_log)
          allow(conf).to receive(:rails).and_return(conf_rails)
          # OPTIMIZE: Retro-fix siblings to use this form.
          allow(conf_console).to receive(:enabled).and_return(of_conf_console_enabled) if defined?(of_conf_console_enabled)
          allow(conf_log).to receive(:enabled).and_return(of_conf_log_enabled) if defined?(of_conf_log_enabled)
          allow(conf_rails).to receive(:enabled).and_return(of_conf_rails_enabled) if defined?(of_conf_rails_enabled)
          allow(envi).to receive(:rails).and_return(of_envi_rails) if defined?(of_envi_rails)
        end

        describe "#t_console" do
          context_when of_conf_console_enabled: false do
            it { is_expected.to be nil }
          end

          context_when of_conf_console_enabled: true do
            it { is_expected.to be_a Target::Console }
          end
        end

        describe "#t_log" do
          context_when of_conf_log_enabled: false do
            it { is_expected.to be nil }
          end

          context_when of_conf_log_enabled: true do
            it do
              allow(envi).to receive(:root_path).and_return("/some/path")
              expect(subject.root_path).to eq "/some/path"
              is_expected.to be_a Target::Log
            end
          end
        end

        # TODO: Organize.
        describe "#t_rails" do
          context_when of_conf_rails_enabled: false, of_envi_rails: nil do
            it { is_expected.to be nil }

            context_when of_conf_rails_enabled: true do
              it { is_expected.to be nil }
            end

            context_when of_envi_rails: Object.new do
              it { is_expected.to be nil }
            end
          end

          context "when provided" do
            let(:of_conf_rails_enabled) { true }
            let(:of_envi_rails) { Object.new }
            it do
              expect(subject.rails).to eq of_envi_rails
              is_expected.to be_a Target::Rails
            end
          end
        end
      end

      describe "#do_p1" do
        # NOTE: This is highly important. `conf` attribute hasn't got a default,
        #       but we use values from it here, like `obj.conf.format` and stuff.
        let(:conf) { Config.new }

        context_when conf: nil do
          # TODO: Should crash.
          pending("TODO")
        end

        context_when args: ["some-caller", "some-arg", described_class::Options::DoP.new(prefix: "pfx")] do
          let(:full_msg) { double "full_msg" }

          it "generally works" do
            expect(described_class::FullMsg).to receive(:new).with({
              arg: args[1],
              caller_line: args[0],
              format: obj.conf.format,
              loc_length: obj.conf.loc_length,
              prefix: args[2].prefix,
              root_path: obj.envi.root_path,
            }).and_return(full_msg)
            expect(full_msg).to receive(:formatted).and_return("of_fmf")

            expect(obj).to receive(:print_to_console).with("of_fmf")
            expect(obj).to receive(:print_to_log).with("of_fmf")

            subject
          end
        end
      end

      # TODO: Organize.
      describe "`print_to_*`", focus: true do
        let(:args) { ["full_message"] }

        describe "#print_to_console" do
          context_when t_console: nil do
            it { is_expected.to be nil }
          end

          context "when provided" do
            let(:t_console) { double "t_console" }

            it do
              expect(t_console).to receive(:print).with(args[0])
              subject
            end
          end
        end

        describe "#print_to_log" do
          context_when t_log: nil do
            it { is_expected.to be nil }
          end

          context "when provided" do
            let(:t_log) { double "t_log" }

            it do
              expect(t_log).to receive(:print).with(args[0])
              subject
            end
          end
        end

        describe "#print_to_rails" do
          context_when t_rails: nil do
            it { is_expected.to be nil }
          end

          context "when provided" do
            let(:t_rails) { double "t_rails" }

            it do
              expect(t_rails).to receive(:print).with(args[0])
              subject
            end
          end
        end
      end # describe "`print_to_*`"

      # TODO: Fin.
      # describe "`print_to_*`" do
      #   let(:conf) { double "conf" }

      #   describe "#print_to_console" do
      #     let(:conf_console) { double "conf.console" }
      #     let(:t_console) { double "t_console" }

      #     before :each do
      #       allow(conf).to receive(:console).and_return(conf_console)
      #       allow(obj).to receive(:t_console).and_return(t_console)
      #       defined?(of_conf_console_enabled) and allow(conf_console).to receive(:enabled).with(no_args).and_return(of_conf_console_enabled)
      #     end

      #     context_when args:["full message"] do
      #       context_when of_conf_console_enabled: true do
      #         it do
      #           expect(t_console).to receive(:print).with(args[0])
      #           subject
      #         end
      #       end

      #       context_when of_conf_console_enabled: false do
      #         it do
      #           expect(t_console).not_to receive(:print)
      #           subject
      #         end
      #       end
      #     end
      #   end # describe "#print_to_console"

      #   describe "#print_to_log" do
      #     let(:conf_log) { double "conf.log" }
      #     let(:t_log) { double "t_log" }

      #     before :each do
      #       allow(conf).to receive(:log).and_return(conf_log)
      #       allow(obj).to receive(:t_log).and_return(t_log)
      #       defined?(of_conf_log_enabled) and allow(conf_log).to receive(:enabled).with(no_args).and_return(of_conf_log_enabled)
      #     end

      #     context_when args:["full message"] do
      #       context_when of_conf_log_enabled: true do
      #         it do
      #           expect(t_log).to receive(:print).with(args[0])
      #           subject
      #         end
      #       end

      #       context_when of_conf_log_enabled: false do
      #         it do
      #           expect(t_log).not_to receive(:print)
      #           subject
      #         end
      #       end
      #     end
      #   end # describe "#print_to_log"
      # end # describe "`print_to_*`"

    end # describe "private methods"

    # OPTIMIZE: A few sporadic end-to-end tests once everything settles nicely.
  end # describe
end
