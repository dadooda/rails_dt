require "cgi"
require "erb"

Dir[File.join(File.dirname(__FILE__), "dt/**/*.rb")].each {|fn| require fn} 

# Debug toolkit.
#
# Allows to output debug messages from anywhere in your Rails project.
#
# Configure your application:
#   $ script/generate rails_dt
#
# Follow the instructions the generator gives you.
#
# Then anywhere in your application do a:
#   DT.p "Hello, world!"
#   DT.p "myvar", myvar
#
# , and see it in web output, console, and <tt>log/dt.log</tt>.
module DT   #:doc:
  # NOTE: Alphabetical order in this section.

  # Clear messages.
  def self.clear
    @messages = []
  end

  # Return messages accumulated since last cleared.
  def self.messages
    @messages
  end

  # Dump a value or several values. Similar to Ruby's native <tt>p</tt>.
  #   p "my var: " + myvar.inspect
  #   p @myobj
  def self.p(*args)
    # Fetch caller information.
    # NOTE: May be lacking file information, e.g. when in an irb session.
    file, line = caller.first.split(":")

    # Template variables. Documented in web_prefix=.
    hc = {
      :file => file,
      :line => line,
      :file_base => (begin; File.basename(file); rescue; file; end),
      :file_rel => (begin; Pathname(file).relative_path_from(Rails.root).to_s; rescue; file; end),
    }

    ##return hc

    args.each do |r|
      s = r.is_a?(String) ? r : r.inspect

      # NOTE: "Canonical" order of imporance: web, console, log.

      # To Web.
      if self.web_prefix
        pfx = ERB.new(self.web_prefix, nil, "-").result(_hash_kbinding(hc))

        pcs = []
        pcs << pfx
        pcs << CGI.escapeHTML(s).gsub("\n", "<br/>\n")
        pcs << "<br/>\n"
        @messages << pcs.join
      end

      # To console.
      if self.console_prefix
        pfx = ERB.new(self.console_prefix, nil, "-").result(_hash_kbinding(hc))
        puts [pfx, s].join
      end

      # To log.
      if self.log_prefix and @log
        pfx = ERB.new(self.log_prefix, nil, "-").result(_hash_kbinding(hc))
        @log.info [pfx, s].join
      end
    end

    # Be like puts -- more comfy when debugging in console.
    nil
  end

  # Format accumulated messages as HTML.
  #   to_html      # => Something like "<ul><li>A message!</li></ul>".
  def self.to_html
    pcs = []
    pcs << "<ul>"
    @messages.each do |s|
      pcs << ["<li>", s, "</li>"].join
    end
    pcs << "</ul>"

    pcs.join
  end

  #--------------------------------------- Control stuff

  # Set message prefix for console. See <tt>web_prefix=</tt>.
  def self.console_prefix=(s)
    @console_prefix = s
  end

  def self.console_prefix
    @console_prefix
  end

  # Set logger to use. Must be a <tt>Logger</tt>.
  #   log = Logger.new("log/my.log")
  def self.log=(obj)
    raise "Logger expected, #{obj.class} given" if not obj.is_a? Logger
    @log = obj
  end

  def self.log
    @log
  end

  # Set message prefix for log. See <tt>web_prefix=</tt>.
  def self.log_prefix=(s)
    @log_prefix = s
  end

  def self.log_prefix
    @log_prefix
  end

  # Set message prefix for web. Syntax is ERB.
  #   web_prefix = '<a href="txmt://open?url=file://<%= file %>&line=<%= line %>"><%= file_rel %>:<%= line %></a> '
  #
  # Template variables:
  # * <tt>file</tt> -- full path to file
  # * <tt>line</tt> -- line number
  # * <tt>file_base</tt> -- file base name
  # * <tt>file_rel</tt> -- file name relative to Rails application root
  #
  # By setting prefix to <tt>nil</tt> you disable respective output.
  #   web_prefix = nil      # Web output is disabled now.
  def self.web_prefix=(s)
    @web_prefix = s
  end

  def self.web_prefix
    @web_prefix
  end

  #---------------------------------------

  # NOTE: Singletons can't be private, so mark them syntactically.

  # Turn hash's entries into locals and return binding.
  # Useful for simple templating.
  def self._hash_kbinding(h)    #:nodoc:
    # NOTE: This IS important, since assignment is eval'd in this context.
    bnd = binding

    _value = nil
    h.each do |k, _value|
      ##puts "-- k-#{k.inspect} v-#{_value.inspect}"
      eval("#{k} = _value", bnd)
    end

    bnd
  end

  #--------------------------------------- Initialization

  def self._init    #:nodoc:
    # Require Rails environment.
    if not defined? Rails
      raise "Rails environment not found. This module is meaningful in Rails only"
    end

    clear

    # NOTE: Don't forget to update generator/initializers/dt.rb with these.
    self.web_prefix = '<a href="txmt://open?url=file://<%= file %>&line=<%= line %>"><%= file_rel %>:<%= line %></a> '
    self.console_prefix = "[DT <%= file_rel %>:<%= line %>] "
    self.log_prefix = self.console_prefix

    # In case of path problems @log will be nil.
    @log = begin
      Logger.new("log/dt.log")
    rescue Exception
    end
  end

  _init

end # DT
