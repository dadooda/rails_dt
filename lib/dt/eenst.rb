
require_relative "konf"

"LODoc"

module DT
  # Main class.
  class Eenst
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :envi
    attr_writer :konf

    def envi
      @envi ||= Environment.new
    end

    def konf
      @konf ||= Konf.new
    end

    private

    # @param [String] caller_line
    # @return [Array<String>] <tt>[file, line]</tt>.
    def extract_file_line(caller_line)
      caller_line.split(":")[0..1]
    end

    # @param [String] file
    # @return [String]
    def format_file_rel(file)
      begin
        Pathname(file).relative_path_from(envi.root_path).to_s
      rescue ArgumentError
        file
      end
    end

    # @param [Array<String>] caller
    # @param [String] msg
    # @return [String, String] File and line number.
    def format_location(callerXX = "kk")
      raise "STOPPED HERE"
      # p "caller", caller
    end
  end
end
