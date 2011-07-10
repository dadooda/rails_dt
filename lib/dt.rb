require "cgi"
require "erb"

Dir[File.join(File.dirname(__FILE__), "dt/**/*.rb")].each {|fn| require fn} 

# Debug toolkit.
#
# Allows to print debug messages from anywhere in your Rails project. Do a:
#
#   DT.p "Hello, world!"
#
# , and see the message in log, <tt>log/dt.log</tt>, console and web.
#
# To set up web output, in your application root do a:
#
#   $ rails generate rails_dt     # Rails 3
#   $ script/generate rails_dt    # Rails 2
#
# Follow the instructions the generator gives you then.
module DT   #:doc:
  # Maximum number of stored messages, if they're not cleared.
  # If web output is configured, messages are cleared before every request.
  MAX_WEB_MESSAGES = 100

  # Initializer.
  def self._initialize    #:nodoc:
    clear_web_messages

    # NOTES:
    # * Stuffing is inserted in order to work around buggy RDoc parser.
    #   "a""bc" => "abc", just in case.
    # * Don't forget to update generator/initializers/dt.rb with these.
    # * "Canonical" order of imporance: log, console, web.
    @log_prefix = "[DT <""%= file_rel %>:<""%= line %>] "
    @console_prefix = @log_prefix.dup
    @web_prefix = '<a href="txmt://open?url=file://<''%= file %>&line=<''%= line %>"><''%= file_rel %>:<''%= line %></a> '

    # In case of path problems @log will be nil.
    @log = Logger.new(Rails.root + "log/dt.log") rescue nil
  end

  # On-the-fly initializer.
  def self._otf_init    #:nodoc:
    # Consider job done, replace self with a blank.
    class_eval {
      def self._otf_init    #:nodoc:
      end
    }

    _initialize
  end

  # Set message prefix for console. See <tt>log_prefix=</tt>.
  def self.console_prefix=(s)
    _otf_init
    @console_prefix = s
  end

  def self.console_prefix
    _otf_init
    @console_prefix
  end

  # Set logger to use. Must be a <tt>Logger</tt>.
  #
  #   log = Logger.new("log/my.log")
  def self.log=(obj)
    _otf_init
    raise "Logger expected, #{obj.class} given" if not obj.is_a? Logger
    @log = obj
  end

  def self.log
    _otf_init
    @log
  end

  # Set message prefix for log. Syntax is ERB.
  #
  #   log_prefix = "[DT <""%= file_rel %>:<""%= line %>] "
  #
  # NOTE: In the above example some stuffing was made to satisfy the buggy RDoc parser.
  # Just in case, <tt>"a""bc"</tt> is <tt>"abc"</tt> in Ruby.
  #
  # Template variables:
  #
  # * <tt>file</tt> -- full path to file.
  # * <tt>file_base</tt> -- file base name.
  # * <tt>file_rel</tt> -- file name relative to Rails application root.
  # * <tt>line</tt> -- line number.
  #
  # By setting prefix to <tt>nil</tt> you disable respective output.
  #
  #   web_prefix = nil      # Disable web output.
  def self.log_prefix=(s)
    _otf_init
    @log_prefix = s
  end

  def self.log_prefix
    _otf_init
    @log_prefix
  end

  # Return messages accumulated since last cleared.
  def self.web_messages
    _otf_init
    @web_messages
  end

  # Set message prefix for web. See <tt>log_prefix=</tt>.
  def self.web_prefix=(s)
    _otf_init
    @web_prefix = s
  end

  def self.web_prefix
    _otf_init
    @web_prefix
  end

  #---------------------------------------

  # Clear messages.
  def self.clear_web_messages
    _otf_init
    @web_messages = []
  end

  # Print a debug message or dump a value. Somewhat similar to Ruby's native <tt>p</tt>.
  #
  #   p "Hello, world!"
  #   p "myvar", myvar
  def self.p(*args)
    _otf_init
    # Fetch caller information.
    # NOTE: May be lacking file information, e.g. when in an irb session.
    file, line = caller.first.split(":")

    # Assign template variables.
    hc = {
      :file => file,
      :line => line,
      :file_base => (begin; File.basename(file); rescue; file; end),
      :file_rel => (begin; Pathname(file).relative_path_from(Rails.root).to_s; rescue; file; end),
    }

    args.each do |r|
      s = r.is_a?(String) ? r : r.inspect

      # To log.
      if @log_prefix
        ##Kernel.p "@log", @log   #DEBUG
        if @log
          pfx = ERB.new(@log_prefix, nil, "-").result(_hash_kbinding(hc))
          msg = [pfx, s].join
          @log.info msg
          Rails.logger.info msg rescue nil    # In case something's wrong with `Rails.logger`.
        end
      end

      # To console.
      if @console_prefix
        pfx = ERB.new(@console_prefix, nil, "-").result(_hash_kbinding(hc))
        puts [pfx, s].join
      end

      # To web.
      if @web_prefix
        pfx = ERB.new(@web_prefix, nil, "-").result(_hash_kbinding(hc))

        pcs = []
        pcs << pfx
        pcs << CGI.escapeHTML(s).gsub("\n", "<br/>\n")
        @web_messages << pcs.join

        # Rotate messages.
        @web_messages.slice!(0..-(MAX_WEB_MESSAGES + 1))
      end
    end

    # Be like `puts`, return nil.
    nil
  end

  # Format accumulated web messages as HTML. Usually called from a view template.
  #
  #   web_messages_as_html    # => Something like "<ul><li>Message 1</li><li>Message 2</li>...</ul>".
  def self.web_messages_as_html
    _otf_init

    pcs = []
    pcs << "<ul>"
    @web_messages.each do |s|
      pcs << ["<li>", s, "</li>"].join
    end
    pcs << "</ul>"

    if (out = pcs.join).respond_to? :html_safe
      out.html_safe
    else
      out
    end
  end

  #---------------------------------------

  # NOTE: Singletons can't be private, so mark them syntactically.

  # Turn hash's entries into locals and return binding.
  # Useful for simple templating.
  def self._hash_kbinding(h)    #:nodoc:
    # NOTE: This IS important, since assignment is eval'd in this context.
    bnd = binding

    _value = nil
    h.each do |k, v|
      ##puts "-- k-#{k.inspect} v-#{_value.inspect}"    #DEBUG
      _value = v      # IMPORTANT: Ruby 1.9 compatibility hack.
      eval("#{k} = _value", bnd)
    end

    bnd
  end

  # DO NOT invoke `_initialize` load-time, it won't see Rails3 stuff.
end # DT
