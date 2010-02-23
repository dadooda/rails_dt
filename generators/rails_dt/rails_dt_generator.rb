#class SessionGenerator < Rails::Generator::NamedBase   # <-- was
class RailsDtGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "stylesheets/dt.css", "public/stylesheets/dt.css"
      m.file "initializers/dt.rb", "config/initializers/dt.rb"
      m.readme "INSTALL"
    end
  end
end
