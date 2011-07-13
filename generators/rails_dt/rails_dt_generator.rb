class RailsDtGenerator < Rails::Generator::Base   #:nodoc:
  def manifest
    record do |m|
      m.file((fn = "dt.css"), "public/stylesheets/#{fn}")
      m.file((fn = "dt.rb"), "config/initializers/#{fn}")
      m.readme "INSTALL"
    end
  end
end
