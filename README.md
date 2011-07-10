Rails Debug Toolkit
===================

Introduction
------------

`rails_dt` gem gives you `DT.p()` method you can use anywhere in your project to print your debug messages.

It's somewhat similar to Ruby's native `p()` with output being sent to log, console and web.

For example, `DT.p "Hello, world!"` invoked in `RootController` will give you a:

    [DT app/controllers/root_controller.rb:3] Hello, world!


The Ideas Behind It
-------------------

* Debug message printer must **not require initialization**.
* Debug message printer must be **nothing else**, but a debug message printer.
* Debug message printer must be simple and invoked **always the same way** regardless of where you call it from.
* Debug message printer calls must be **clearly visible** in the code.
* Debug message printer must **print its location in code** so you can find and modify/remove it as easy as possible.


Express Setup (Rails 3)
-----------------------

In your `Gemfile`, add:

    gem "rails_dt"

Then do a `bundle install`.

This gives you an express (zero-conf) setup, which outputs messages to log, `log/dt.log` and console.


Express Setup (Rails 2)
-----------------------

    $ gem sources --add http://rubygems.org
    $ gem install rails_dt

In your `config/environment.rb`, add:

    config.gem "rails_dt"


Setting Up Web Output (Both Rails 3 and Rails 2)
------------------------------------------------

In your application root, do a:

    $ rails generate rails_dt     # Rails 3
    $ script/generate rails_dt    # Rails 2

Follow the instructions the generator gives you then. They are listed below.

Inside your `ApplicationController` class, add:

    handles_dt

Inside your `app/views/layouts/application.html.erb` `<head>` section, add:

    <%= stylesheet_link_tag "dt" %>

Inside your `app/views/layouts/application.html.erb` `<body>` section, add:

    <div class="DT">
      <%= DT.web_messages_as_html %>
    </div>


Checking Setup
--------------

Somewhere in your `app/views/layouts/application.html.erb`, add:

    <% DT.p "hello, world!" %>

Refresh the page. You should see "hello, world!":

* In your application log.
* In `log/dt.log`.
* On the web page, if you've set it up (see above).


Debugging...
------------

### ...Models ###

    def before_save
      DT.p "in before_save"
    end

### ...Controllers ###

    def action
      DT.p "hi, I'm #{action_name}"
    end

### ...Views ###

    <div class="body">
      <% DT.p "@users", @users %>
    </div>

### ...Filters ###

Insert debugging code:

    before_filter do
      DT.p "in before_filter xyz"
    end

    after_filter do
      DT.p "in after_filter xyz"
    end

See it in action:

    $ tail -f log/dt.log

### ...Anything! ###

Just use `DT.p` anywhere you want.


Customizing Output Format
-------------------------

Create a sample initializer, by doing a:

    $ rails generate rails_dt     # Rails 3
    $ script/generate rails_dt    # Rails 2

In `config/initializers/dt.rb` you'll see something like:

    # Customize your DT output.
    #DT.log_prefix = "[DT <%= file_rel %>:<%= line %>] "
    #DT.console_prefix = "[DT <%= file_rel %>:<%= line %>] "
    #DT.web_prefix = '<a href="txmt://open?url=file://<%= file %>&line=<%= line %>"><%= file_rel %>:<%= line %></a> '

Uncomment and edit lines appropriately. Restart server for changes to take effect.

Values are in ERB format. The following macros are available:

* `file` -- full path to file.
* `file_base` -- file base name.
* `file_rel` -- file name relative to Rails application root.
* `line` -- line number.

You can also disable particular output target by setting its prefix to `nil`:

    DT.console_prefix = nil     # Disable console output.


Feedback
--------

Send bug reports, suggestions and criticisms through [project's page on GitHub](http://github.com/dadooda/rails_dt).
