# encoding: utf-8
require 'attach_file_field'

module AttachFileField
  if defined? Rails::Railtie
    require 'rails'
    class Railtie < Rails::Railtie
      ActiveSupport.on_load :active_record do        
        ActiveRecord::Base.send :include, AttachFileField::Base
      end
      
      initializer "attach_file_field.add_middleware" do |app|
        app.middleware.insert_before(
          ActionDispatch::Cookies,
          AttachFileField::Middleware,
          app.config.send(:session_options)[:key])
      end
    
      config.after_initialize do
        ActionView::Base.send(:include, AttachFileField::ViewHelper)
        ActionView::Helpers::FormBuilder.send(:include, AttachFileField::FormBuilder)
      end
      
      generators do
        require "generators/attach_file_field"
      end
    end
  end
end
