# encoding: utf-8
module AttachFileField
  autoload :Utils,        'attach_file_field/utils'
  autoload :ViewHelper,   'attach_file_field/view_helper'
  autoload :FormBuilder,  'attach_file_field/form_builder'
  autoload :Middleware,   'attach_file_field/middleware'
  autoload :Version,      'attach_file_field/version'
  autoload :Base,         'attach_file_field/base'
  
  module Hooks
    autoload :SimpleFormBuilder, 'attach_file_field/hooks/simple_form'
  end
end

require 'attach_file_field/railtie'
