module AttachFileField
  module Hooks
    module SimpleFormBuilder
      class AttachFileInput < ::SimpleForm::Inputs::Base
        def input
          @builder.send(:attach_file, attribute_name, input_html_options)
        end
      end
      
      def self.included(base)
        base.send(:include, InstanceMethods)
      end
    
      module InstanceMethods
        def attach_file(attribute_name, options={}, &block)
          column     = find_attribute_column(attribute_name)
          input_type = default_input_type(attribute_name, column, options)

          if block_given?
            SimpleForm::Inputs::BlockInput.new(self, attribute_name, column, input_type, options, &block).render
          else
            AttachFileInput.new(self, attribute_name, column, input_type, options).render
          end
        end
      end
    end
  end
end
