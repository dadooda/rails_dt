class RailsDtGenerator < Rails::Generators::Base    #:nodoc:
  source_root File.expand_path("../templates", __FILE__)

  def go
    copy_file (fn = "dt.css"), "public/stylesheets/#{fn}"
    copy_file (fn = "dt.rb"), "config/initializers/#{fn}"
    readme "INSTALL"
  end
end
