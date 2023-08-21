
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

      describe "#fn" do
        pending("TODO")
      end

      describe "#do_p" do
        pending("TODO")
      end
    end

    describe "private methods" do
      subject { obj.send(m, *(defined?(args) ? args : [])) }

      describe "#envi" do
        it { is_expected.to be_a Environment  }
      end

      describe "#do_p1" do
        let(:args) { ["some-caller", "some-arg", described_class::Options::DoP.new(prefix: "pfx")] }

        # NOTE: This is highly important. `conf` attribute hasn't got a default,
        #       but we use values from it here, like `obj.conf.format` and stuff.
        let(:conf) { Config.new }

        context_when conf: nil do
          it do
            expect { subject }.to raise_error(RuntimeError, "Attribute `conf` must not be nil: nil")
          end
        end

        context "when regular" do
          let(:full_msg) { double "full_msg" }
          let(:of_fmf) { "result of full_msg.format" }
          let(:t_console) { double "t_console" }
          let(:t_log) { double "t_log" }
          let(:t_rails) { double "t_rails" }

          it "generally works" do
            expect(described_class::FullMsg).to receive(:new).with({
              arg: args[1],
              caller_line: args[0],
              format: obj.conf.format,
              loc_length: obj.conf.loc_length,
              prefix: args[2].prefix,
              root_path: obj.envi.root_path,
            }).and_return(full_msg)
            expect(full_msg).to receive(:formatted).and_return(of_fmf)

            expect(obj).to receive(:print_to_console).with(of_fmf)
            expect(obj).to receive(:print_to_log).with(of_fmf)
            expect(obj).to receive(:print_to_rails).with(of_fmf)

            subject
          end
        end
      end

      describe "#print_to_*", focus: true do
        let(:args) { ["full_message"] }
        let(:conf) { double "conf" }
        let(:conf_console) { double "conf.console" }
        let(:conf_log) { double "conf.log" }
        let(:conf_rails) { double "conf.rails" }
        let(:t_console) { double "t_console" }
        let(:t_log) { double "t_log" }

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

        describe "#print_to_console" do
          context_when of_conf_console_enabled: false do
            it do
              expect(t_console).not_to receive(:print)
              subject
            end
          end

          context_when of_conf_console_enabled: true do
            it do
              expect(t_console).to receive(:print).with(args[0])
              subject
            end
          end
        end

        describe "#print_to_log" do
          context_when of_conf_log_enabled: false do
            it do
              expect(t_log).not_to receive(:print)
              subject
            end
          end

          context_when of_conf_log_enabled: true do
            it do
              expect(t_log).to receive(:print).with(args[0])
              subject
            end
          end
        end

        describe "#print_to_rails" do
          let(:t_rails) { double "t_rails" }

          context_when t_rails: nil do
            context_when of_conf_rails_enabled: false do
              it do
                expect(t_rails).not_to receive(:print)
                subject
              end
            end

            context_when of_conf_rails_enabled: true do
              it do
                expect(t_rails).not_to receive(:print)
                subject
              end
            end
          end

          context "when `t_rails` provided" do
            context_when of_conf_rails_enabled: false do
              it do
                expect(t_rails).not_to receive(:print)
                subject
              end
            end

            context_when of_conf_rails_enabled: true do
              it do
                expect(t_rails).to receive(:print).with(args[0])
                subject
              end
            end
          end
        end # describe "#print_to_rails"
      end # describe "`print_to_*`"

      describe "#t_*", focus: true do
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
          it { is_expected.to be_a Target::Console }
        end

        describe "#t_log" do
          it do
            allow(envi).to receive(:root_path).and_return("/some/path")
            expect(subject.root_path).to eq "/some/path"
            is_expected.to be_a Target::Log
          end
        end

        describe "#t_rails" do
          context_when of_envi_rails: nil do
            it { is_expected.to be nil }
          end

          context "when `envi.rails` provided" do
            let(:of_envi_rails) { double "envi.rails" }
            it do
              expect(subject.rails).to eq of_envi_rails
              is_expected.to be_a Target::Rails
            end
          end
        end
      end # describe "#t_*"
    end # describe "private methods"

    # OPTIMIZE: A few sporadic end-to-end tests once everything settles nicely.
  end # describe
end
