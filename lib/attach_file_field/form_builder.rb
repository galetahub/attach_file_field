# encoding: utf-8
module AttachFileField
  module FormBuilder
    def self.included(base)
      base.send(:include, AttachFileField::ViewHelper)
      base.send(:include, AttachFileField::FormBuilder::ClassMethods)
    end
    
    module ClassMethods
      def attach_file(method, options={})
    	  attach_file_tag(@object_name, method, objectify_options(options))
      end
    end
  end
end
