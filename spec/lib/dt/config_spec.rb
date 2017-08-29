
require "dt/config"

describe DT::Config do
  def newo(attrs = {})
    described_class.new(attrs)
  end

  describe "#env" do
    it "generally works" do
      r = newo
      expect(r.env).to eq ENV

      r = newo(env: {"USER" => "tom"})
      expect(r.env["USER"]).to eq "tom"
    end
  end

  describe "`#rails` and friends" do
    it "generally works" do
      r = newo
      expect(r.rails).to be nil
      expect(r.rails?).to be false

      r = newo(rails: (rails = Object.new))
      expect(r.rails).to eq rails
      expect(r.rails?).to be true
    end
  end

  describe "#root_path" do
    context "in Rails mode" do
      it "generally works" do
        rails = Class.new do
          def root
            Pathname("/some/path")
          end
        end.new

        r = newo(rails: rails)
        expect(r.root_path).to eq "/some/path"
      end
    end

    context "in non-Rails mode" do
      it "generally works" do
        r = newo(env: {"BUNDLE_GEMFILE" => "/some/path/Gemfile"})
        expect(r.root_path).to eq "/some/path"

        r = newo(env: {})
        expect(r.root_path).to eq Dir.pwd
      end
    end
  end
end