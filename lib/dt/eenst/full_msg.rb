
require_relative "../eenst"

module DT; class Eenst
  # A disposable self-formatting full message.
  class FullMsg
    Feature::AttrMagic.load(self)

    # Caller line information.
    # @return [String] E.g. <tt>"/path/to/project/file1.rb:201:in `meth'"</tt>.
    attr_accessor :caller_line

    # Length limit for the +%{loc}+ token.
    # @return [Fixnum]
    attr_accessor :loc_length

    # @return [String]
    attr_accessor :msg

    # @return [Pathname]
    attr_accessor :root_path

    def initialize(attrs = {})
      attrs.each { |k, v| public_send("#{k}=", v) }

      # A compatible way to force attribute(s) construction-time.
      require_attr :caller_line
      require_attr :msg
      require_attr :root_path
      require_attr :loc_length
    end

    private

    # File and line information.
    # @return [[String, String]] File and line number.
    def file_line
      igetset(__method__) do
        ar = caller_line.split(":")[0..1]
        if ar.size == 2 && ar[1].length > 0
          ar
        else
          # Misformatted input. Keep the full original, stuff "?" as line number.
          [caller_line, "?"]
        end
      end
    end

    # A relative file path.
    # @return [String]
    def file_rel
      require_attr :root_path

      igetset(__method__) do
        file = file_line[0]

        begin
          xd_pathname.new(file).relative_path_from(root_path).to_s
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
    end

    # A +%{full_loc}+ message token.
    # @return [String]
    def full_loc
      igetset(__method__) { "#{file_rel}:#{file_line[1]}" }
    end

    # A +%{loc}+ message token.
    # @return [String]
    def loc
      require_attr :loc_length

      igetset(__method__) do
        truncated = full_loc[-(loc_length - 1)..-1]

        if truncated
          "…" + truncated
        else
          # Right-align.
          sprintf "%*s", loc_length, full_loc
        end
      end
    end

    # External dependency.
    # @return [Pathname]
    def xd_pathname
      @xd_pathname ||= Pathname
    end
  end
end; end
