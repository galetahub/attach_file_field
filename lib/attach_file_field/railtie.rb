# encoding: utf-8
require 'rails'
require 'attach_file_field'

module AttachFileField
  class Railtie < ::Rails::Railtie
    config.before_initialize do
      ActiveSupport.on_load :active_record do        
        ActiveRecord::Base.send :include, AttachFileField::Base
      end
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
      
      if Object.const_defined?("SimpleForm")
        ::SimpleForm::FormBuilder.send :include, AttachFileField::Hooks::SimpleFormBuilder
      end
    end
  end
end
