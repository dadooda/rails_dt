
require_relative "../eenst"

module DT; class Eenst
  # A disposable self-formatting full message.
  class FullMsg
    Feature::AttrMagic.load(self)
    Feature::Initialize.load(self)

    # The value we turn into an +%{msg}+ message token.
    # @return [mixed]
    attr_accessor :arg

    # Caller line information.
    # @return [String] E.g. <tt>"/path/to/project/file1.rb:201:in `meth'"</tt>.
    attr_accessor :caller_line

    # Message format.
    # @return [String]
    # @see Konf#format
    attr_accessor :format

    # Length limit for the +%{loc}+ token.
    # @return [Fixnum]
    attr_accessor :loc_length

    # @return [Pathname]
    attr_accessor :root_path

    # @return [String]
    def fullmsg
      igetset(__method__) do
        require_attr :format
        format % tokens
      end
    end

    private

    # @note These are for well-balanced and consistent tests.
    attr_writer :file, :file_line, :file_rel, :full_loc, :line, :loc, :msg

    # The file part of {#file_line}.
    # @return [String]
    def file
      igetset(__method__) { file_line[0] }
    end

    # File and line information.
    # @return [[String, String]] File and line number.
    def file_line
      igetset(__method__) do
        require_attr :caller_line

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
      igetset(__method__) do
        require_attr :root_path

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
      igetset(__method__) { "#{file_rel}:#{line}" }
    end

    # The line part of {#file_line}.
    # @return [String]
    def line
      igetset(__method__) { file_line[1] }
    end

    # A +%{loc}+ message token.
    # @return [String]
    def loc
      igetset(__method__) do
        require_attr :loc_length

        truncated = full_loc[-(loc_length - 1)..-1]

        if truncated
          "…" + truncated
        else
          # Right-align.
          sprintf "%*s", loc_length, full_loc
        end
      end
    end

    # An +%{msg}+ message token.
    # @return [String]
    def msg
      igetset(__method__) { arg.is_a?(String) ? arg : arg.inspect }
    end

    # A message tokens hash.
    # @return [Hash]
    def tokens
      {
        full_loc: full_loc,
        loc: loc,
        msg: msg,
      }
    end

    # External dependency.
    # @return [Pathname]
    def xd_pathname
      @xd_pathname ||= Pathname
    end
  end
end; end
