module DT
  module ActionControllerExtensions   #:nodoc:
    def self.included(owner)    #:nodoc:
      owner.extend MetaClassMethods
    end

    module MetaClassMethods
      # Inform framework that our controller handles DT.
      #   class ApplicationController < ActionController::Base
      #     handles_dt
      #   end
      def handles_dt
        # NOTE: after_filter() is nicer and lets debug more, but... It's not getting control when there's a rendering exception, such as 404.
        #       Use console and log to debug complex stuff like prefilters.
        before_filter {DT.clear}
      end
    end # MetaClassMethods
  end # ActionControllerExtensions
end # DT

# NOTE: This MUST be outside DT module, otherwise rdoc will produce ugly doc for DT module.
if defined? ::ActionController::Base
  module ::ActionController    #:nodoc:
    class Base    #:nodoc:
      include DT::ActionControllerExtensions
    end
  end
end
