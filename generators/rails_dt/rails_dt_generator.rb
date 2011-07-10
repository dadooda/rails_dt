class RailsDtGenerator < Rails::Generator::Base   #:nodoc:
  def manifest
    record do |m|
      m.file "stylesheets/dt.css", "public/stylesheets/dt.css"
      m.file "initializers/dt.rb", "config/initializers/dt.rb"
      m.readme "INSTALL"
    end
  end
end
