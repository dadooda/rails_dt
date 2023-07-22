
require_relative "konf"

"LODoc"

module DT
  # Main class.
  class Eenst
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    attr_writer :envi
    attr_writer :konf

    # @return [Environment]
    def envi
      @envi ||= Environment.new
    end

    # @return [Konf]
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
        p "file", file
        # Computation seems to choke.
        raise "STOPPED HERE"
        xd_pathname(file).relative_path_from(envi.root_path).to_s
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

    # External dependency.
    # @return [Kernel]
    def xd_kernel
      @xd_kernel ||= Kernel
    end

    # External dependency.
    # @return [Pathname]
    def xd_pathname
      @xd_pathname ||= Pathname
    end
  end
end
