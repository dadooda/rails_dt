
require_relative "../../libx/feature/attr_magic"
require_relative "../../libx/feature/initialize"
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

    # Extract file and line information.
    # @param [String] caller_line E.g. <tt>"/path/to/project/file1.rb:201:in `meth'"</tt>.
    # @return [[String, String]] File and line number.
    def extract_file_line(caller_line)
      caller_line.split(":")[0..1]
    end

    # Format a relative file path.
    # @param [String] file
    # @return [String]
    def format_file_rel(file)
      begin
        xd_pathname.new(file).relative_path_from(envi.root_path).to_s
      rescue ArgumentError => e
        # Handle known errors only:
        #
        #   different prefix: "" and "/some/path"'
        #
        # Default to `file` as is.
        if e.message.start_with? "different prefix:"
          file
        else
          raise e
        end
      end
    end

    # Format a +%{full_loc}+ message token.
    # @param [String] caller_line
    # @param [String] msg
    # @return [String]
    def format_full_loc(caller_line)
      file, line = extract_file_line(caller_line)
      [format_file_rel(file), line].join(":")
    end

    # Format a +%{loc}+ message token.
    # @param [String] caller_line
    # @param [String] msg
    # @return [String]
    def format_loc(caller_line)
      limit = konf.loc_length
      full = format_full_loc(caller)
      truncated = full[-(limit - 1)..-1]

      if truncated
        "…" + truncated
      else
        # Right-align.
        sprintf "%*s", limit, full
      end
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
