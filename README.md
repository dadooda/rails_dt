Rails Debug Toolkit
===================

Introduction
------------

`rails_dt` gem gives you `DT.p()` method you can use anywhere in your project to print variable dumps, debug messages etc.

It's similar to Ruby's native `p()` with output being sent to browser, console and log.


Setup
-----

    $ gem sources --add http://gemcutter.org
    $ gem install rails_dt

In your application root, do a:

    $ script/generate rails_dt

Follow the instructions the generator gives you (they are listed below):

In your `app/controllers/application_controller`, add:

    handles_dt

In your `app/view/layouts/application.html.erb` `<head>` section, add:

    <%= stylesheet_link_tag "dt" %>

Somewhere at the end of your `app/views/layouts/application.html.erb` `<body>` section, add:

    <div class="DT">
      <%= DT.to_html %>
    </div>


Debugging...
------------

### ...models ###

    def before_save
      DT.p "in before_save"
    end

### ...controllers ###

    def action
      DT.p "hi, I'm #{action_name}"
    end

### ...views ###

    <div class="body">
      <% DT.p "@users", @users %>
    </div>

### ...filters ###

Insert debugging code:

    before_filter do
      DT.p "in before_filter xyz"
    end

    after_filter do
      DT.p "in after_filter xyz"
    end

See it in action:

    $ tail -f log/dt.log


Feedback
--------

Send bug reports, suggestions and criticisms through [project's page on GitHub](http://github.com/dadooda/rails_dt).
